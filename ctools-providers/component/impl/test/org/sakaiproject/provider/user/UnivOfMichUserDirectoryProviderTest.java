package org.sakaiproject.provider.user;

/*
  $HeadURL$
  $Id$
 */

import java.util.Collection;
import java.util.Vector;

import org.sakaiproject.user.api.UserEdit;
import org.sakaiproject.user.api.UserFactory;
import org.sakaiproject.util.api.umiac.UmiacClient;

import junit.framework.TestCase;

import org.jmock.*;

public class UnivOfMichUserDirectoryProviderTest extends MockObjectTestCase {

	UnivOfMichUserDirectoryProvider uomudp = null;
	Mock mockUmiacClient = null;
	UmiacClient uc = null;
	
	protected void setUp() throws Exception {
		super.setUp();
		uomudp = new UnivOfMichUserDirectoryProvider();
		mockUmiacClient = mock(UmiacClient.class);
		uc = (UmiacClient) mockUmiacClient.proxy();
		uomudp.setUmiac(uc);
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
//	public Collection findUsersByEmail(String email, UserFactory factory)
//	{
//		Collection rv = new Vector();
//
//		// get a UserEdit to populate
//		UserEdit edit = factory.newUser();
//
//		// assume a "@local.host"
//		int pos = email.indexOf("@umich.edu");
//		if (pos != -1)
//		{
//			String id = email.substring(0, pos);
//			edit.setEid(id);
//			if (getUser(edit)) rv.add(edit);
//		}
//
//		return rv;
//	}

	public void testFindUsersByEmailUmich() {
		Mock mockUserFactory = mock(UserFactory.class);
		UserFactory uf = (UserFactory) mockUserFactory.proxy();		
		
		Mock mockUserEdit = mock(UserEdit.class);
		UserEdit ue = (UserEdit) mockUserEdit.proxy();
		// should pull out the user name
		mockUserEdit.expects(once()).method("setEid").with(eq("ME"));
		mockUserEdit.expects(atLeastOnce()).method("getEid").will(returnValue("ME"));
		// should set then email and type in the object.
		mockUserEdit.expects(atLeastOnce()).method("setEmail").with(eq("ME@umich.edu"));
		mockUserEdit.expects(atLeastOnce()).method("setType").with(eq("uniqname"));
		
		mockUserFactory.expects(once()).method("newUser").will(returnValue(ue));

			// check umiac from userExists
		mockUmiacClient.expects(once()).method("userExists").will(returnValue(true));
		mockUmiacClient.expects(once()).method("setUserNames");
		
		Collection c = uomudp.findUsersByEmail("ME@umich.edu",uf);
		assertEquals("found user",1,c.size());
	}
	
	public void testFindUsersByEmailIgnoringSubdomainUmichBiz() {
		Mock mockUserFactory = mock(UserFactory.class);
		UserFactory uf = (UserFactory) mockUserFactory.proxy();		
		
		Mock mockUserEdit = mock(UserEdit.class);
		UserEdit ue = (UserEdit) mockUserEdit.proxy();
		// should pull out the user name
		mockUserEdit.expects(once()).method("setEid").with(eq("ME"));
		mockUserEdit.expects(atLeastOnce()).method("getEid").will(returnValue("ME"));
		// should set then email and type in the object.
		mockUserEdit.expects(atLeastOnce()).method("setEmail").with(eq("ME@umich.edu"));
		mockUserEdit.expects(atLeastOnce()).method("setType").with(eq("uniqname"));
		
		mockUserFactory.expects(once()).method("newUser").will(returnValue(ue));

			// check umiac from userExists
		mockUmiacClient.expects(once()).method("userExists").will(returnValue(true));
		mockUmiacClient.expects(once()).method("setUserNames");
		
		Collection c = uomudp.findUsersByEmail("ME@biz.umich.edu",uf);
		assertEquals("found user",1,c.size());
	}
	
	public void testFindUsersByEmailIgnoringSubdomainUmichMulti() {
		Mock mockUserFactory = mock(UserFactory.class);
		UserFactory uf = (UserFactory) mockUserFactory.proxy();		
		
		Mock mockUserEdit = mock(UserEdit.class);
		UserEdit ue = (UserEdit) mockUserEdit.proxy();
		// should pull out the user name
		mockUserEdit.expects(once()).method("setEid").with(eq("ME"));
		mockUserEdit.expects(atLeastOnce()).method("getEid").will(returnValue("ME"));
		// should set then email and type in the object.
		mockUserEdit.expects(atLeastOnce()).method("setEmail").with(eq("ME@umich.edu"));
		mockUserEdit.expects(atLeastOnce()).method("setType").with(eq("uniqname"));
		
		mockUserFactory.expects(once()).method("newUser").will(returnValue(ue));

			// check umiac from userExists
		mockUmiacClient.expects(once()).method("userExists").will(returnValue(true));
		mockUmiacClient.expects(once()).method("setUserNames");
		
		Collection c = uomudp.findUsersByEmail("ME@none.of.your.biz.umich.edu",uf);
		assertEquals("found user",1,c.size());
	}
	
//  	public void testFindUsersByEmailNotAcceptingSubdomain() {
//  		Mock mockUserFactory = mock(UserFactory.class);
//  		UserFactory uf = (UserFactory) mockUserFactory.proxy();		
		
//  		Mock mockUserEdit = mock(UserEdit.class);
//  		UserEdit ue = (UserEdit) mockUserEdit.proxy();
		
//  		mockUserFactory.expects(once()).method("newUser").will(returnValue(ue));
		
//  		// will not recognize when use subdomain.
//  		Collection c = uomudp.findUsersByEmail("ME@biz.umich.edu",uf);
//  		assertEquals("found user",0,c.size());
//  	}


	
	
//	public void testFindUserByEmail() {
//		fail("Not yet implemented");
//	}

}
