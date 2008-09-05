/* *************** Stopwatch ************* */

// Stopwatch is a class that will compute elapsed time (and count events if desired).

// It is explicitly 
// included here since the current sash implementation doesn't pick up other files.

/*
  benchmark / stats
  - take a comment
  - record start and end.
  - record the successful events (and unsuccessful?)
  - print a summary 

  ?? Should there be a "lap" or "sofar" method that gives result without
  having to call stop?  It uses the current time as the temporary stop value.

  TTD 
  - Constructor should have a 1 MS sleep to avoid problems with very fast 
  elapsed times.
  - Should have explicit constructor that takes a string since it is too easy 
  to forget to pass in the comment as named argument.

  s1 = new Stopwatch("comment")
  s1.start(); // start recording stats
  s1.stop();  // stop recording stats.
  s1.startTime();  // return the start time
  s1.stopTime();   // return the stop time
  s1.markEvent(); note that event occurred
  s1.eventCnt();  // how many events have there been?
  s1.summaryNums(); returns list of elapsed MS, num events, and events / MS.
  s1.summary() // returns a summary string elapsed, num events, avg
  s1.toString() // provide a default summary naming the stopwatch and giving elapsed time, num events and event rate.
*/

class Stopwatch {
  
  // default comment
  String comment = "default comment";

  // start and stop time stamps.
  def startMS = 0;
  def stopMS = 0;
  def eventCnt = 0;
  
  // initialize the stopwatch and return the start time in MS
  def start() {
    startMS = System.currentTimeMillis();
  }

  def startTime() {
    return startMS;
  }

  // stop the timing and return the stop time in MS.
  def stop() {
    stopMS = System.currentTimeMillis();
  }

  def stopTime() {
    return stopMS;
  }

  // handle events
  def markEvent() {
    eventCnt++;
  }

  def eventCnt() {
    return eventCnt;
  }

  // compute the summary values
  def summaryNums() {
    // if the watch hasn't been started / stopped use an interim value based on 
    // the current time.  This allow computing the results so far.
    def useStartMS = (startMS ? startMS : System.currentTimeMillis());
    def useStopMS = (stopMS ? stopMS : System.currentTimeMillis());
    def elapsed = useStopMS-useStartMS;
    Float rate = 0;
    if (elapsed) {
      rate = eventCnt / elapsed;
    }
    else {
      rate = -1;
    }
    // return a list of the important numbers.
    [elapsed,eventCnt,rate];
  }

  // return a printable summary
  def summary() {
    def summary = summaryNums();
    // format the rate
    Float tmp = summary[2];
    def formatted = sprintf("%4.3f",tmp);
    "elapsed: ${summary[0]} events: ${summary[1]} events_per_MS: ${formatted}";
  }
  
  // provide a useful default summary string.
  def String toString() {
    "${comment} "+summary();
  }
}

