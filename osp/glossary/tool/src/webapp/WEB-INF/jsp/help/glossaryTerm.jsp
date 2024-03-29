<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<fmt:setLocale value="${locale}"/>
<fmt:setBundle basename = "org.theospi.portfolio.glossary.bundle.Messages"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title><c:out value="${entry.term}" /></title>
</head>
<body style="font: small  verdana">
	<h3><c:out value="${entry.term}" /></h3>
	<div class="textPanel"><c:out value="${entry.longDescription}" escapeXml="false" /></div>
	<p class="act">
		<input type="button" name="Close" value='<fmt:message key="button.close"/>'
			onclick="window.close()">
	</p>
</body>
</html>
