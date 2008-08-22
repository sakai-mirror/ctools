#!/usr/bin/env groovy

// $HeadURL:$
// $Id:$

import Stopwatch;

class StopwatchTest extends GroovyTestCase {

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

//    void testEventsNone() {
//      def startTime = sw.start();
//      def stopTime = sw.stop();
//      assert sw.eventCnt() == 0;
//    }

//    void testEventsOne() {
//      def startTime = sw.start();
//      sw.markEvent();
//      def stopTime = sw.stop();
//      assert sw.eventCnt() == 1;
//    }

   void checkEventsN(n) {
     def numEvents = n;
     def startTime = sw.start();
     (1..n).each{sw.markEvent();}
     def stopTime = sw.stop();
     assert sw.eventCnt() == n;
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

//      def numEvents = 5;
//      def startTime = sw.start();
//      (1..numEvents).each{sw.markEvent()};
//      def stopTime = sw.stop();
//      assert sw.eventCnt() == numEvents;
//   }
  

}

// end

