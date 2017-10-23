// [[Rcpp::depends(BH)]]
#include <boost/interprocess/file_mapping.hpp>
#include <boost/interprocess/mapped_region.hpp>
#include <Rcpp.h>

using namespace Rcpp;
using namespace boost::interprocess;
using std::size_t;

inline size_t ceil4(size_t n) {
  return (n + 3) / 4;
}

class bedadapt2 {
public:
  bedadapt2(std::string path, int n, int p, const NumericMatrix& lookup);
  
  size_t nrow() const { return n; }
  size_t ncol() const { return p; }
  
  inline double operator() (size_t i, size_t j) {
    const unsigned char byte = file_data[_ind_div[i] + j * n_byte];
    return _lookup(_ind_mod[i], byte);
  }
  
  NumericVector AF();
  // NumericVector prodMatVec(const NumericVector &x, 
  //                          const NumericVector &m, 
  //                          const NumericVector &s,
  //                          const LogicalVector &pass);
  // NumericVector prodtMatVec(const NumericVector &x, 
  //                           const NumericVector &m, 
  //                           const NumericVector &s,
  //                           const LogicalVector &pass);
  // NumericMatrix linReg(const NumericMatrix &u,
  //                      const NumericVector &d,
  //                      const NumericMatrix &v,
  //                      const NumericVector &m);
  
private:
  boost::interprocess::file_mapping file;
  boost::interprocess::mapped_region file_region;
  const unsigned char* file_data;
  size_t n;
  size_t p;
  size_t n_byte;
  NumericMatrix _lookup;
  std::vector<size_t> _ind_div;
  std::vector<size_t> _ind_mod;
};

/******************************************************************************/
/* Inspired from
https://github.com/QuantGen/BEDMatrix/blob/master/src/BEDMatrix.cpp 
https://github.com/privefl/bigstatsr/blob/master/src/FBM.cpp */

/******************************************************************************/

bedadapt2::bedadapt2(std::string path, int n, int p,
                     const NumericMatrix& lookup) : 
  n(n), p(p), n_byte(ceil4(n)), _lookup(lookup) {
  
  // Rcout << this->n << " ; " << this->p << " ; " << this->n_byte << std::endl;
  
  std::vector<size_t> ind_div(n);
  std::vector<size_t> ind_mod(n);
  for (int i = 0; i < n; i++) {
    ind_div[i] = static_cast<size_t>(i / 4);
    ind_mod[i] = static_cast<size_t>(i % 4);
  }
  this->_ind_div = ind_div;
  this->_ind_mod = ind_mod;
  
  // Rcout << this->_ind_div[0] << std::endl;
  
  try {
    this->file = file_mapping(path.c_str(), read_only);
  } catch(interprocess_exception& e) {
    throw std::runtime_error("File not found.");
  }
  
  this->file_region = mapped_region(this->file, read_only);
  this->file_data = 
    static_cast<const unsigned char*>(this->file_region.get_address());
  
  if (!(this->file_data[0] == '\x6C' && this->file_data[1] == '\x1B')) {
    throw std::runtime_error("File is not a binary PED file.");
  }
  
  /* Check mode: 00000001 indicates the default variant-major mode (i.e.
  list all samples for first variant, all samples for second variant,
  etc), 00000000 indicates the unsupported sample-major mode (i.e. list
  all variants for the first sample, list all variants for the second
  sample, etc */
  if (this->file_data[2] != '\x01') {
    throw std::runtime_error("Sample-major mode is not supported.");
  }
  
  // Point after this magic number
  this->file_data += 3;
  
  // Check if given dimensions match the file
  if ((3 + this->n_byte * this->p) != this->file_region.get_size()) {
    throw std::runtime_error("n or p does not match the dimensions of the file.");
  }
}

/******************************************************************************/

// [[Rcpp::export]]
SEXP bedadapt2XPtr(std::string path, int n, int p, const NumericMatrix& lookup) {
  
  // http://gallery.rcpp.org/articles/intro-to-exceptions/
  try {
    /* Create a pointer to a bedadapt2 object and wrap it as an external pointer
    http://dirk.eddelbuettel.com/code/rcpp/Rcpp-modules.pdf */
    XPtr<bedadapt2> ptr(new bedadapt2(path, n, p, lookup), true);
    // Return the external pointer to the R side
    return ptr;
  } catch(std::exception &ex) {
    forward_exception_to_r(ex);
    return 0;
  }
}

/******************************************************************************/

NumericVector bedadapt2::AF() {
  
  size_t n = this->n;
  size_t m = this->p;
  size_t i, j, n_available;
  
  double x;
  
  NumericVector maf(m);
  
  for (j = 0; j < m; j++) {
    
    n_available = n; // Counts the number of available values for SNP j
    
    for (i = 0; i < n; i++) {
      x = this->operator()(i, j);
      if (x == 3) { // Checking a 3 is much faster that checking a NA
        n_available--;
      } else {
        maf[j] += x;
      }
    }
    
    maf[j] /= 2 * n_available;
  }
  
  return Rcpp::pmin(maf, 1 - maf);
}

// [[Rcpp::export]]
NumericVector cmpt_af2(RObject xp_) {
  XPtr<bedadapt2> ptr(xp_);
  return ptr->AF();
}

/******************************************************************************/

// NumericVector bedadapt2::prodMatVec(const NumericVector &x, 
//                                     const NumericVector &m, 
//                                     const NumericVector &s,
//                                     const LogicalVector &pass) {
//   // Input vector of length p
//   // Output vector of length n
//   NumericVector y(this->n);
//   for (size_t j = 0; j < this->p; j++) {
//     if (pass[j]) {
//       size_t byte_start = byte_position(this->n + this->byte_padding, j);
//       size_t byte_end = byte_position(this->n + this->byte_padding, j + 1);
//       size_t i = 0;
//       char raw_element;
//       char genotype;
//       for (size_t byte = byte_start; byte < byte_end; byte++) {
//         raw_element = get_byte(byte);
//         for (size_t idx = 0; idx < 4; idx++) {
//           genotype = raw_element >> (idx * 2) & 3;
//           if (genotype == 0 && i < this->n) {
//             y[i] += ((2.0 - 2 * m[j]) * x[j]) / s[j]; // homozygous AA
//           } else if (genotype == 2 && i < this->n) {
//             y[i] += ((1.0 - 2 * m[j]) * x[j]) / s[j]; // heterozygous AB
//           } else if (genotype == 3 && i < this->n) {
//             y[i] -= 2 * m[j] * x[j] / s[j]; // heterozygous BB
//           } 
//           i++;
//         }
//       }
//     }
//   }
//   return y;
// }
// 
// // [[Rcpp::export]]
// RObject prodMatVec2(RObject xp_, 
//                     const NumericVector &x, 
//                     const NumericVector &m, 
//                     const NumericVector &s,
//                     const LogicalVector &pass) {
//   // Convert inputs to appropriate C++ types
//   XPtr<bedadapt2> ptr(xp_);
//   NumericVector res = ptr->prodMatVec(x, m, s, pass);
//   return res;
// }

/******************************************************************************/

// NumericVector bedadapt2::prodtMatVec(const NumericVector &x, 
//                                      const NumericVector &m, 
//                                      const NumericVector &s,
//                                      const LogicalVector &pass) {
//   // Input vector of length n
//   // Output vector of length p
//   Rcpp::NumericVector y(this->p);
//   for (size_t j = 0; j < this->p; j++) {
//     if (pass[j]) {
//       size_t byte_start = byte_position(this->n + this->byte_padding, j);
//       size_t byte_end = byte_position(this->n + this->byte_padding, j + 1);
//       size_t i = 0; // i-th individual
//       char raw_element;
//       char genotype;
//       for (size_t byte = byte_start; byte < byte_end; byte++) {
//         raw_element = get_byte(byte);
//         for (size_t idx = 0; idx < 4; idx++) {
//           genotype = raw_element >> (idx * 2) & 3;
//           if (genotype == 0 && i < this->n) {
//             y[j] += ((2.0 - 2 * m[j]) * x[i]) / s[j]; // homozygous AA
//           } else if (genotype == 2 && i < this->n) {
//             y[j] += ((1.0 - 2 * m[j]) * x[i]) / s[j]; // heterozygous AB
//           } else if (genotype == 3 && i < this->n) {
//             y[j] -= 2 * m[j] * x[i] / s[j]; // heterozygous BB
//           }
//           i++;
//         }
//       }
//     }
//   }
//   return y;
// }
// 
// // [[Rcpp::export]]
// RObject prodtMatVec2(RObject xp_, 
//                      const NumericVector &x, 
//                      const NumericVector &m, 
//                      const NumericVector &s,
//                      const LogicalVector &pass) {
//   // Convert inputs to appropriate C++ types
//   XPtr<bedadapt2> ptr(xp_);
//   NumericVector res = ptr->prodtMatVec(x, m, s, pass);
//   return res;
// }

/******************************************************************************/

// NumericMatrix bedadapt2::linReg(const NumericMatrix &u,
//                                 const NumericVector &d,
//                                 const NumericMatrix &v,
//                                 const NumericVector &m) {
//   size_t K = u.ncol();
//   NumericMatrix Z(this->p, K); // z-scores
//   IntegerVector G(this->n);
//   
//   for (size_t j = 0; j < this->p; j++) {
//     /* Compute the residuals */
//     G = this->extractSNP(j);
//     double residual = 0;
//     size_t n_available = 0;
//     NumericVector sum_squared_u(K);   
//     for (size_t i = 0; i < this->n; i++) {
//       double y = 0;
//       for (size_t k = 0; k < K; k++) {
//         y += u(i, k) * d[k] * v(j, k) ; // Y = UDV
//       }
//       if (!IntegerVector::is_na(G[i])) {
//         double tmp = y - (G[i] - 2 * m[j]) / sqrt(2 * m[j] * (1 - m[j]));
//         residual += tmp * tmp;
//         n_available++;
//         for (size_t k = 0; k < K; k++) {
//           // sum_squared_u = 1 if SNP j has no missing value
//           // sum_squared_u < 1 if SNP j has at least one missing value
//           sum_squared_u[k] += u(i, k) * u(i, k); 
//         }
//       } 
//     }
//     
//     /* t-score */
//     for (size_t k = 0; k < K; k++) {
//       if (residual > 0 && n_available > K) {
//         Z(j, k) = v(j, k) * d[k] / sqrt(residual / (n_available - K));
//       }
//       if (sum_squared_u[k] > 0) {
//         // this should never happen
//         Z(j, k) /= sqrt(sum_squared_u[k]);
//       }
//     }
//   }
//   return Z;
// }
// 
// // [[Rcpp::export]]
// RObject linReg2(RObject xp_, 
//                 const NumericMatrix &u, 
//                 const NumericVector &d, 
//                 const NumericMatrix &v, 
//                 const NumericVector &m) {
//   // Convert inputs to appropriate C++ types
//   XPtr<bedadapt2> ptr(xp_);
//   NumericVector res = ptr->linReg(u, d, v, m);
//   return res;
// }