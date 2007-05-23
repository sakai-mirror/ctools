package org.sakaiproject.component.legacy.coursemanagement;

import junit.framework.*;

/**
 * @author dlhaines
 *
 */
public class CmTest extends TestCase{


//	public static void main(String[] args) {
//		// TODO Auto-generated method stub
////		   junit.textui.TestRunner.run(
////		            TestThatWeGetHelloWorldPrompt.class);
//	}
	
	public void testReplaceComma () {
		String commas = ",,,";
		String spaces = "   ";
		assertEquals(commas.replace(',',' '),spaces);
	}

}
