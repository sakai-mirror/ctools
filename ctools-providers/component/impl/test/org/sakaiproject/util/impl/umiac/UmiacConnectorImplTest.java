package org.sakaiproject.util.impl.umiac;

import org.jmock.Mock;
import org.jmock.MockObjectTestCase;
import org.sakaiproject.component.api.ServerConfigurationService;

/*
 * This is a basic configuration for testing the UmiacConnector.  It is not a complete test suite, add to is 
 * as necessary to deal with bugs that come up.
 * 
 * Currently real logging is used, so there is console output that can (usually) be ignored.
 * 
 */

public class UmiacConnectorImplTest extends MockObjectTestCase {

	// Note that very likely to want to call uci.init(), but will want to have
	// the proper things injected first. 
	UmiacConnectorImpl uci = new UmiacConnectorImpl();
	String umiacAddressString = "UMIAC.ADDRESS.VALUE";
	String umiacPort = "8888";
	
	protected void setUp() throws Exception {
		super.setUp();
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
	/*
	 * This method illustrates basic testing.  Other tests should be added as necessary.
	 * 
	 */
	
	public void testConfigurationService() {
		
		Mock mockServerConfigurationService = mock(ServerConfigurationService.class);
		ServerConfigurationService scs = (ServerConfigurationService) mockServerConfigurationService.proxy();	
		
		mockServerConfigurationService.expects(once()).method("getString").with(eq("umiac.address"),eq(null)).will(returnValue(umiacAddressString));
		mockServerConfigurationService.expects(once()).method("getString").with(eq("umiac.port"),eq("-1")).will(returnValue(umiacPort));
		uci.setServerConfigurationService(scs);
		uci.init();
		assertEquals("serverConfigurationService host name",umiacAddressString,uci.getHost());
		assertEquals("serverConfigurationService port",Integer.parseInt(umiacPort),uci.getPort());
	}

}
