<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- GUID=<c:out value="${newTermId}" /> -->

<osp-c:authZMap prefix="osp.help.glossary." var="can" />
<osp-c:authZMap prefix="" var="canWorksite" useSite="true" />

<fmt:setLocale value="${locale}"/>
<fmt:setBundle basename = "org.theospi.portfolio.glossary.bundle.Messages"/>

<div class="navIntraTool">
    <c:if test="${can.add}">
        <a href="<osp:url value="editGlossaryTerm.osp"/>" title="<fmt:message key="label_title_new"/>">
        <fmt:message key="action_new"/></a>
    </c:if>
    
    <c:if test="${can.add}">
        <a href="<osp:url value="importGlossaryTerm.osp"/>" title="<fmt:message key="label_import"/>">
        <fmt:message key="action_import"/> </a>
    </c:if>
    
    <c:if test="${can.export && not empty glossary}">
	    <a href="<osp:url includeQuestion="false" value="/repository/1=1"/>&manager=helpManagerTarget&templateId=<c:out value="${template.id.value}"/>/<c:out value="${worksite.title}" /> Glossary.zip"><fmt:message key="action_export"/></a>
    </c:if>
    
    <c:if test="${canWorksite.maintain}">
        <a href="<osp:url value="osp.permissions.helper/editPermissions">
			<osp:param name="message"> 
				<fmt:message key="message_permissionsEdit">
				  <fmt:param><c:out value="${tool.title}"/></fmt:param>
				  <fmt:param><c:out value="${worksite.title}"/></fmt:param>
				  </fmt:message>
			</osp:param>
			<osp:param name="name" value="glossary"/>
			<osp:param name="qualifier" value="${tool.id}"/>
			<osp:param name="returnView" value="glossaryListRedirect"/>
		</osp:url>"
            title="<fmt:message key="action_permissions_title"/>">
            <fmt:message key="action_permissions"/></a>
    </c:if>
</div>

<div class="navPanel">
	<div class="viewNav">
		<c:if test="${!global}">
			<h3><fmt:message key="title_glossaryManager"/></h3>
		</c:if>
		<c:if test="${global}">
			<h3><fmt:message key="title_glossaryManagerGlobal"/></h3>
		</c:if>
	</div>	
	
	<osp:url var="listUrl" value="glossaryList.osp" />
	<osp:listScroll listUrl="${listUrl}" className="listNav" />
</div>	


<c:if test="${import_success}">
   <div class="success"><fmt:message key="import_msg_success"/></div>
</c:if>
<c:if test="${import_unrecognized_file}">
   <div class="alertMessage"><fmt:message key="import_msg_bad_file"/></div>
</c:if>
<c:if test="${import_failed}">
   <div class="alertMessage"><fmt:message key="import_msg_failed"/></div>
</c:if>
<c:if test="${import_bad_parse}">
   <div class="alertMessage"><fmt:message key="import_msg_bad_file_parse"/></div>
</c:if>
<c:choose>
	<c:when test="${not empty glossary}">
		<table class="listHier lines nolines" cellspacing="0" cellpadding="0"  border="0" summary="<fmt:message key="glossary_list_summary"/>">
			<thead>
				<tr>
					<th scope="col"><fmt:message key="label_Term"/></th>
					<th scope="col"></th>
					<th scope="col"><fmt:message key="label_desc"/></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="term" items="${glossary}">
		
					<tr>
						<td style="white-space:nowrap">
							<osp-h:glossary link="true" hover="false"><c:out value="${term.term}" /></osp-h:glossary>
						</td>
						<td style="white-space:nowrap" class="itemAction">
							<c:if test="${can.edit || can.delete}">
								<c:if test="${can.edit}">
									<a href="<osp:url value="editGlossaryTerm.osp"/>&id=<c:out value="${term.id}" />"><fmt:message key="table_action_edit"/></a>
								</c:if>
								<c:if test="${can.edit && can.delete}">
									|
								</c:if>
								<c:if test="${can.delete}">
									<a href="<osp:url value="removeGlossaryTerm.osp"/>&id=<c:out value="${term.id}" />"><fmt:message key="table_action_delete"/></a>
								</c:if>
							</c:if>
						</td>
		
						<td class="textPanel textPanelFooter"><c:out value="${term.description}" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</c:when>
	<c:otherwise>
		<p class="instruction">
			<fmt:message key="glossary_list_emptymessage"/>
		</p>
	</c:otherwise>
	</c:choose>	