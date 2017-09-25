#' @importFrom R6 R6Class
MQParameters_R6Class <- R6::R6Class(
  'MQParameters',
  public=list(
    initialize=function(file_path=NA) {
      private$location <- file_path
      mq_parameters <- read.delim(file_path, stringsAsFactors=FALSE)
      mq_parameters <-
        setNames(mq_parameters$Value, mq_parameters$Parameter)
      private$mq_version <- unname(mq_parameters['Version'])
      private$fasta_file <-
        gsub('\\\\', '/', strsplit(mq_parameters['Fasta file'], ';')[[1]])
    },
    # this method returns the version
    getVersion=function() {
      private$mq_version
    },
    # this methods returns the fastafile.
    # @param new_param it is possible to rewrite the basedir.
    getFastaFile=function(new_basedir=NA) {
      if(is.na(new_basedir)) {
        private$fasta_file
      } else {
        file.path(new_basedir, basename(private$fasta_file))
      }
    }
  ),
  private=list(
    location=NULL,
    mq_version=NULL,
    fasta_file=NULL
  )
)

df <- data.frame(Parameter=c('Version', 'Fasta file'),
                 Value=c('1.5.2.8','c:\\a\\b.fasta'))
write.table(df, 'jnk.txt', sep='\t', row.names=F)

p <- MQParameters$new('jnk.txt')
MQParameters <- function(file_path = NA) {
  MQParameters_R6Class$new(file_path)
}
p <- MQParameters('jnk.txt')
