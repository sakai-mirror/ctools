/**********************************************************************************
 * $URL$
 * $Id$
 ***********************************************************************************
 *
 * Copyright (c) 2007 The Sakai Foundation.
 *
 * Licensed under the Educational Community License, Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.opensource.org/licenses/ecl1.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **********************************************************************************/

package org.theospi.portfolio.wizard.taggable.api;

import org.sakaiproject.assignment.taggable.api.TaggableActivity;
import org.sakaiproject.assignment.taggable.api.TaggableActivityProducer;
import org.sakaiproject.assignment.taggable.api.TaggableItem;
import org.theospi.portfolio.matrix.model.WizardPage;
import org.theospi.portfolio.matrix.model.WizardPageDefinition;

/**
 * A producer of wizard pages as taggable activities.
 * 
 * @author The Sakai Foundation.
 */
public interface WizardActivityProducer extends TaggableActivityProducer {

	/**
	 * The identifier of this producer.
	 */
	public static final String PRODUCER_ID = WizardActivityProducer.class
			.getName();

	/**
	 * Method to wrap the given wizard page definition as a taggable activity.
	 * 
	 * @param wizardPageDef
	 *            The wizard page definition.
	 * @return The wizard page definition represented as a taggable activity.
	 */
	public TaggableActivity getActivity(WizardPageDefinition wizardPageDef);

	/**
	 * Method to wrap the given wizard page as a taggable item.
	 * 
	 * @param wizardPage
	 *            The wizard page.
	 * @return The wizard page represented as a taggable item.
	 */
	public TaggableItem getItem(WizardPage wizardPage);
}
