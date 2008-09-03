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
// new TestArgsX(args).perform(); // simple version
new TestArgsY(args).perform(); // argument parsing

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

 class TestArgsY {

   // hold the argument array
   def ar ;
   // hold the command line interface builder.
   def cli;
   // hold results of parsing the command line.
   def options; 

   // constructor will copy the args directly from the script.
   TestArgsY(String[] a) {
     println "TestArgsY created at: ${new Date()}";
     println "testing cli";
     ar = a;
     ar.each{println "ar: ${it}"};
     cli = new CliBuilder(usage: "test cli");
      cli.h(longOpt: 'help', 'usage information');
      cli.b(longOpt: 'batchSize',args: 1,'number of sites to process in each batch.');
      cli.n(longOpt: 'numberOfBatches',args: 1,'number of batches to process.');
      cli.c(longOpt: 'count',args: 1,'number of candidate sites left.');
     
      options = cli.parse(a);
      println options;

      println cli.usage();

      if (!options) println "cli error";

      if (options.h) println cli.usage();
      if (options.c) println "howdy: c: ${options.c}";

   }

   // the script is started by explicitly calling a routine to take the
   // place of main.
   void perform() {
     println "args: ar:";
     ar.each{println "[${it}]"};
   }
 }

// end
