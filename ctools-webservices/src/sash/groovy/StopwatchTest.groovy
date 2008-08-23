#!/usr/bin/env groovy

// $HeadURL$
// $Id$

import Stopwatch;

class StopwatchTest extends GroovyTestCase {

  // set to 1 if want to see some timing results.
  def verbose = 0;

  /* Setup */
  def sw;
  void setUp() {
    sw = new Stopwatch();
  }


  /* contructor tests */
  void testDefaultConstructor() {
    assert sw.comment == "default comment";
  }

  void testStringConstructor() {
    def String nc = "NEWCOMMENT";
    // note use of named parameters in constructor.
    def newsw = new Stopwatch(comment : nc);
    assert newsw.comment == nc;
  }

  /* sanity check start and stop */
  void testStart() {
    def st = sw.start();
    //sanity check that the time is in the right ball park.
    assert st > 1219434606583;
    assert st != null;
    assert st == sw.startTime();
    // check that don't get new time when ask for startTime
    sleep 5;
    assert st == sw.startTime();
  }

  void testStop() {
    def sstart = sw.start();
    sleep (1);
    def st = sw.stop();
    assert st != null;
    assert st == sw.stopTime();
    // check that don't get new time when ask for stopTime after things are stopped
    sleep 5;
    assert st == sw.stopTime();
  }

  void testStoDiff0() {
    sw.start();
    sw.stop();
    assert sw.startTime() <= sw.stopTime();
  }

  void testStopDiff5() {
    sw.start();
    sleep(5);
    sw.stop();
    assert sw.startTime() <= sw.stopTime() - 5;
  }

  // Is event counting accurate?

   void checkEventsN(n) {
     def numEvents = n;
     def startTime = sw.start();
     (1..n).each{sw.markEvent();}
     def stopTime = sw.stop();
     assert sw.eventCnt() == n;
   }

  void doEventN(n) {
     def numEvents = n;
     def startTime = sw.start();
     (1..n).each{sw.markEvent();}
     def stopTime = sw.stop();
  }

  void testEvents0() {
     def startTime = sw.start();
     def stopTime = sw.stop();
     assert sw.eventCnt() == 0;
   }

   void testEvents1() {
     checkEventsN(1);
   }
   void testEvents5() {
     checkEventsN(5);
   }
   void testEvents17() {
     checkEventsN(17);
   }

  // Summary output

  void testSummaryNull() {
    assert "elapsed: 0 events: 0 events per MS: NAN" == sw.summary();
  }

  // these tests should be in separate methods so that the sw gets set new each time.
  void testSummary0() {
    checkEventSummary(0);
  }

  void testSummary1() {
    checkEventSummary(1);
  }

  void testSummary2() {
    checkEventSummary(2);
  }

   void testSummary10() {
     checkEventSummary(10);
   }

   void testSummary100() {
     checkEventSummary(100);
   }

   void testSummary1000() {
     checkEventSummary(1000);
   }

   void testSummary10000() {
     checkEventSummary(10000);
   }

   void testSummary100000() {
     checkEventSummary(100000);
   }

   void testSummary1000000() {
     checkEventSummary(1000000);
   }

  def checkEventSummary(n) {
     def startTime = sw.start();
     sleep(1);
     if (n>0) {(1..n).each{sw.markEvent();}};     
     def stopTime = sw.stop();
     def summary = sw.summaryNums();
     if (verbose) {println "${n} ${summary}";};
     // elapsed time is not negative
     assert summary[0] >= 0;
     // number of events is right
     assert summary[1] == n;
     // the rate is less than the time if there were any events.
     assert summary[1] == 0 || summary[1] >= summary[2];
  }

}

// end

