// $HeadURL$
// $Id$


//  Argument passing to a script (without an explicit class) works.
// println args;
// args.each{println "[${it}]"}

println "started at: ${new Date()}";

// With sash 0.1.1 argument passing to a script with a main routine in a class doesn't seem to work.
// To get around this pass the args into the class constructor that is called
// explicitly.  Also invoke the main part of the class explicitly.

// salt away the args and start processing
new TestArgsX(args).perform();

// The class is structured like this:
 class TestArgsX {

   def ar ;

   // constructor will copy the args directly from the script.
   TestArgsX(String[] a) {
     println "TestArgsX created at: ${new Date()}";
     ar = a;
     a.each{println "a: ${it}"}
     ar.each{println "ar: ${it}"}
   }

   // the script is started by explicitly calling a routine to take the
   // place of main.
   void perform() {
     println "args: ar:";
     ar.each{println "[${it}]"};
   }
 }



#end
