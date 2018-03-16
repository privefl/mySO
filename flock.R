#### IN ORDER ####
# In first session, run:
write(1, "test.txt")
obj.lock <- flock::lock("test.txt")
# In second session, this will not run
obj.lock <- flock::lock("test.txt")
write(2, "test.txt", append = TRUE)
flock::unlock(obj.lock)
# Then run this in first session, and session will run when unlocking
write(3, "test.txt", append = TRUE)
flock::unlock(obj.lock)
readLines("test.txt")
