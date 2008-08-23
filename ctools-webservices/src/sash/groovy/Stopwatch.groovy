
// $HeadURL$
// $Id$

/*
  benchmark / stats
  - take a comment
  - record start and end.
  - record the successful events (and unsuccessful?)
  - print a summary 

  s1 = new stats("comment")
  s1.start(); // start recording stats
  s1.stop();  // stop recording stats.
  s1.startTime();  // return the start time
  s1.stopTime();   // return the stop time
  s1.markEvent(); note that event occurred
  s1.eventCnt();  // how many events have there been?
  s1.summary() // returns a summary string start end elapsed, avg

  // s1.resetLap() // start a new lap for recording a subset.
  ?? s1.lap() produce a summary for a subset of the whole duration
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
    def elapsed = stopMS-startMS;
    def rate = 0;
    if (elapsed) {
      rate = eventCnt / elapsed;
    }
    else {
      rate = "NAN";
    }
    [elapsed,eventCnt,rate];
  }

  // give a summary 
  def summary() {
    def summary = summaryNums();
    "elapsed: ${summary[0]} events: ${summary[1]} events per MS: ${summary[2]}";
  }
  
}