<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<fmt:setLocale value="${locale}"/>
<fmt:setBundle basename = "org.theospi.portfolio.presentation.bundle.Messages"/>

<c:set var="commentsCount" value="0" scope="request" />
<c:forEach var="comment" items="${comments}" varStatus="commentsStatus">
    <c:set var="commentsCount" value="${commentsStatus.count}"
        scope="request" />
</c:forEach>

<h3>
	<fmt:message key="title_commentsByMe"/>
</h3>
<p class="instruction">
    <c:if test="${commentsCount == 0}">
      <fmt:message key="title_commentsByMe_none"/>
    </c:if>
    <c:if test="${commentsCount == 1}">
      <fmt:message key="title_commentsByMe_one"/>
    </c:if>
    <c:if test="${commentsCount > 1}">
      <fmt:message key="title_commentsByMe_more">
        <fmt:param><c:out value="${commentsCount}" /></fmt:param>
      </fmt:message>
    </c:if>

   <c:if test="${not empty comments}">
<table class="listHier lines nolines" cellspacing="0"  cellpadding="0" border="0" summary="<fmt:message key="table_commentsByMe_summary"/>">
    <thead>
        <tr>
            <c:set var="sortDir" value="asc" />
            <th scope="col"><c:if test="${sortByColumn == 'name'}">
                <c:if test="${direction == 'asc'}">
                    <c:set var="sortDir" value="desc" />
                </c:if>
            </c:if> <a
                href="<osp:url value="myComments.osp"/>&sortByColumn=name&direction=<c:out value="${sortDir}" />"
				title="<fmt:message key="table_commentsForMe_srt_hint" /><fmt:message key="table_header_presentation"/>">
            <fmt:message key="table_header_presentation"/></a></th>
            <c:set var="sortDir" value="asc" />
            <th scope="col"><c:if test="${sortByColumn == 'title'}">
                <c:if test="${direction == 'asc'}">
                    <c:set var="sortDir" value="desc" />
                </c:if>
            </c:if> <a
                href="<osp:url value="myComments.osp"/>&sortByColumn=title&direction=<c:out value="${sortDir}" />"
				title="<fmt:message key="table_commentsForMe_srt_hint" /><fmt:message key="table_header_comment"/>">
            <fmt:message key="table_header_comment"/></a></th>
            <c:set var="sortDir" value="asc" />
            <th scope="col"><c:if test="${sortByColumn == 'created'}">
                <c:if test="${direction == 'asc'}">
                    <c:set var="sortDir" value="desc" />
                </c:if>
            </c:if> <a
                href="<osp:url value="myComments.osp"/>&sortByColumn=created&direction=<c:out value="${sortDir}" />"
				title="<fmt:message key="table_commentsForMe_srt_hint" /><fmt:message key="table_header_date"/>">
            <fmt:message key="table_header_date"/></a></th>
            <c:set var="sortDir" value="asc" />
            <th scope="col"><c:if test="${sortByColumn == 'owner_id'}">
                <c:if test="${direction == 'asc'}">
                    <c:set var="sortDir" value="desc" />
                </c:if>
            </c:if> <a
                href="<osp:url value="myComments.osp"/>&sortByColumn=owner_id&direction=<c:out value="${sortDir}" />"
				title="<fmt:message key="table_commentsForMe_srt_hint" /><fmt:message key="table_header_presentationOwner"/>">
            <fmt:message key="table_header_presentationOwner"/></a></th>
            <c:set var="sortDir" value="asc" />
            <th scope="col"><c:if test="${sortByColumn == 'visibility'}">
                <c:if test="${direction == 'asc'}">
                    <c:set var="sortDir" value="desc" />
                </c:if>
            </c:if> <a
                href="<osp:url value="myComments.osp"/>&sortByColumn=visibility&direction=<c:out value="${sortDir}" />"
				title="<fmt:message key="table_commentsForMe_srt_hint" /><fmt:message key="table_header_visibility"/>">
            <fmt:message key="table_header_visibility"/></a></th>
        </tr>
    </thead>
    <tbody>

        <c:set value="0" var="odd" />
        <c:forEach begin="0" items="${comments}" var="comment">
             <tr class="lightHighLightRow">
                <td nowrap="nowrap">
                <a target="_blank" 
                    href="<osp:url value="viewPresentation.osp"/>&id=<c:out value="${comment.presentation.id.value}" />#comment<c:out value="${comment.id.value}" />"
					title="<fmt:message key="table_commentsForMe_link_hint"/>">
                <c:out value="${comment.presentation.name}" />(<c:out
                    value="${comment.presentation.template.name}" />) </a>
                
                </td>
                <td>
                <c:out value="${comment.title}" />
                </td>
                <td>
                <c:set var="dateFormat"><fmt:message key="dateFormat_Middle"/></c:set><fmt:formatDate value="${comment.created}" pattern="${dateFormat}"/>
                </td>
                <td>
                <c:out
                    value="${comment.presentation.owner.displayName}" />
                </td>
                <td>
                <c:if test="${comment.visibility == 1}">
               <fmt:message key="comments_private"/>
            </c:if> <c:if test="${comment.visibility == 2}">
               <fmt:message key="comments_shared"/>
            </c:if> <c:if test="${comment.visibility == 3}">
               <fmt:message key="comments_public"/>
            </c:if></P>
                </td>
            </tr>
            <tr class="exclude">

                <td colspan="5">
				<p class="indnt1">
                	<c:out value="${comment.comment}" />
				</p>	
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</c:if>

<form method="post" action="listPresentation.osp" class="inlineForm">
<p class="act">
   <input type="submit" name="_cancel" value="<fmt:message key="button_back"/>" accesskey="x" class="active" />
</p> 
</form>
</p>

