/*******************************************************************************
 * $URL$
 * $Id$
 * **********************************************************************************
 *
 *  Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
 *
 *  Licensed under the Educational Community License, Version 1.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.opensource.org/licenses/ecl1.php
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

package org.sakaiproject.metaobj.shared;

/**
 * Created by IntelliJ IDEA.
 * User: johnellis
 * Date: Oct 24, 2006
 * Time: 7:28:14 AM
 * To change this template use File | Settings | File Templates.
 */
public interface FormHelper {

   public static final String PARENT_ID_TAG = "metaobj.parentId";

   public static final String RETURN_ACTION_TAG = "metaobj.returnAction";

   public static final String RETURN_ACTION_SAVE = "metaobj.save";

   public static final String RETURN_ACTION_CANCEL = "metaobj.cancel";

   public static final String RETURN_REFERENCE_TAG = "metaobj.returnReference";

   public static final String PREVIEW_HOME_TAG = "metaobj.previewHome";

   public static final String PREVIEW_TRANSFORM_STREAM_TAG = "metaobj.previewTransform";

   public static final String NEW_FORM_DISPLAY_NAME_TAG = "metaobj.displayName";
   
   public static final String FORM_STYLES = "metaobj.styles";
   
}
