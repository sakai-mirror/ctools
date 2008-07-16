package org.sakaiproject.util.impl.umiac;


import org.jmock.*;
import org.sakaiproject.memory.api.Cache;
import org.sakaiproject.memory.api.MemoryService;

/*
 * Unit tests of UmiacClient implementation.  Only a few methods are tested as yet and those could be tested more fully.
 * Please add tests as you change the code or chase bugs.
 * 
 * Since UmiacClient is large if you are adding new methods you probably want to copy this class and 
 * edit it to be specific to your new methods.  No point in making this huge and testing everything 
 * every time you want to work on the new methods.
 *  
 */

public class UmiacClientImplUtilTest extends MockObjectTestCase {

	// Note that very likely to want to call uci.init(), but will want to have
	// the proper things injected first. 
	UmiacClientImpl uci = new UmiacClientImpl();
	
	protected void setUp() throws Exception {
		super.setUp();		
	}

	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
	public void testPackIdNull() {
		
		Mock mockCache = mock(Cache.class);
		Cache c = (Cache) mockCache.proxy();	
		
		Mock mockMemoryService = mock(MemoryService.class);
		MemoryService ms = (MemoryService) mockMemoryService.proxy();		
		mockMemoryService.expects(once()).method("newHardCache").will(returnValue(c));
		uci.setMemoryService(ms);
		uci.init();
		assertEquals("Test null id",null,uci.packId(null));
	}
	
	public void testPackIdEmptyStringArray() {
		
		Mock mockCache = mock(Cache.class);
		Cache c = (Cache) mockCache.proxy();	
		
		Mock mockMemoryService = mock(MemoryService.class);
		MemoryService ms = (MemoryService) mockMemoryService.proxy();		
		mockMemoryService.expects(once()).method("newHardCache").will(returnValue(c));
		uci.setMemoryService(ms);
		uci.init();
		String s[] = new String[0];
		assertEquals("Test 0 length array",null,uci.packId(s));
	}
	
	public void testPackIdOneStringArray() {
		
		Mock mockCache = mock(Cache.class);
		Cache c = (Cache) mockCache.proxy();	
		
		Mock mockMemoryService = mock(MemoryService.class);
		MemoryService ms = (MemoryService) mockMemoryService.proxy();		
		mockMemoryService.expects(once()).method("newHardCache").will(returnValue(c));
		uci.setMemoryService(ms);
		uci.init();
		String s[] = new String[] {"ONE"};
		assertEquals("Test 1 length array","ONE",uci.packId(s));
	}

	public void testPackIdTwoStringArray() {
		
		Mock mockCache = mock(Cache.class);
		Cache c = (Cache) mockCache.proxy();	
		
		Mock mockMemoryService = mock(MemoryService.class);
		MemoryService ms = (MemoryService) mockMemoryService.proxy();		
		mockMemoryService.expects(once()).method("newHardCache").will(returnValue(c));
		uci.setMemoryService(ms);
		uci.init();
		String s[] = new String[] {"ONE","TWO"};
		assertEquals("Test 2 length array","ONE+TWO",uci.packId(s));
	}
	
	public void testUnpackIdOneId() {
		Mock mockCache = mock(Cache.class);
		Cache c = (Cache) mockCache.proxy();	
		
		Mock mockMemoryService = mock(MemoryService.class);
		MemoryService ms = (MemoryService) mockMemoryService.proxy();		
		mockMemoryService.expects(once()).method("newHardCache").will(returnValue(c));
		uci.setMemoryService(ms);
		uci.init();
		String out[] = uci.unpackId("ONE");
		assertTrue("one id","ONE".equals(out[0]));
	}
	
	public void testUnpackIdTwoIds() {
		Mock mockCache = mock(Cache.class);
		Cache c = (Cache) mockCache.proxy();	
		
		Mock mockMemoryService = mock(MemoryService.class);
		MemoryService ms = (MemoryService) mockMemoryService.proxy();		
		mockMemoryService.expects(once()).method("newHardCache").will(returnValue(c));
		uci.setMemoryService(ms);
		uci.init();
		String out[] = uci.unpackId("ONE+TWO");
		assertTrue("first id","ONE".equals(out[0]));
		assertTrue("second id","TWO".equals(out[1]));
	}

}
