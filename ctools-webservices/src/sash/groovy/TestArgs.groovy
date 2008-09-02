// $HeadURL:$
// $Id:$


//def main(String args[]) {
//}

// // works !!, can get args into the class
// println args;
// args.each{println "[${it}]"}
// new TestArgsX(args);

println args;
args.each{println "[${it}]"}
new TestArgsX(args).perform();


// empty args
// class TestArgs {

//    public static void main(String[] a) {  
//      println "hello from groovy ${new Date()}";
//      println a;
//      a.each{println "[${it}]"};
//    }

//  }

// get error that args is not defined.
// class TestArgs {

//     public static void main(String[] a) {  
//       println "hello from groovy ${new Date()}";
//       println args;
//       args.each{println "[${it}]"};
//     }
//   }

//def  args;

// run = new TestArgsX(args);
// run.perform();

 class TestArgsX {

   def ar ;

   TestArgsX(String[] a) {
     ar = a;
     a.each{println "a: ${it}"}
     ar.each{println "ar: ${it}"}
   }

   void perform() {
     println "args";
     ar.each{println "[${it}]"};
   }
 }
// //      public static void main(String[] args) {  
// //   //    public static void main() {  
// //       println "hello from groovy ${new Date()}";
// //       println args;
// //       args.each{println "[${it}]"};
// //     }
//   }


// Prints to log, but doesn't notice the args.
// change name from Driver to TestArgs doesn't help.
// class Driver {

//   static void main(String[] args) {  
//     println "hello from groovy ${new Date()}";
//     args.each{println "[${it}]"};
//   }

// }

// Works under sash
//println "hello from groovy ${new Date()}";
//#args.each{println "[${it}]"};
