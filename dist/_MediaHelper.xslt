<?xml version="1.0"?>
<!--
	_MediaHelper.xslt
	
	Enables simple retrieval of media by handling the GetMedia() call and error-checking
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" xmlns:get="urn:Exslt.ExsltMath" version="1.0" exclude-result-prefixes="umb get">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	
	<!-- Fetch cropping setup -->
	<xsl:variable name="croppingSetup" select="document('cropping-config.xml')/crops/crop"/>
	
	<!-- Template for any media that needs fetching - handles potential error -->
	<xsl:template match="*" mode="media">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="id"/>
		<xsl:param name="size"/>
		<xsl:variable name="mediaNode" select="umb:GetMedia(., false())"/>
		<xsl:apply-templates select="$mediaNode[not(error)]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="size" select="$size"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for any mediafolder that needs fetching - handles potential error -->
	<xsl:template match="*" mode="media.folder">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="size"/>
		<xsl:variable name="mediaFolder" select="umb:GetMedia(., true())"/>
		<xsl:apply-templates select="$mediaFolder[not(error)]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="size" select="$size"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for getting a random item from a mediafolder -->
	<xsl:template match="*" mode="media.random">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="size"/>
		<xsl:param name="count" select="1"/><!-- Currently unused -->
		<xsl:variable name="mediaFolder" select="umb:GetMedia(., true())"/>
		<xsl:variable name="randomNumber" select="floor(get:random() * (count($mediaFolder/*[@id])) + 1)"/>
		
		<xsl:apply-templates select="$mediaFolder[not(error)]/*[@id][position() = $randomNumber]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="size" select="$size"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for a Media Folder - default to rendering all images/files inside -->
	<xsl:template match="Folder">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="size"/>
		<xsl:apply-templates select="*[@id]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="size" select="$size"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for a Media Image -->
	<xsl:template match="Image">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="id"/>
		<xsl:param name="size"/>
		<img src="{umbracoFile}" width="{umbracoWidth}" height="{umbracoHeight}" alt="{@nodeName}">
			<xsl:if test="$crop">
				<xsl:variable name="cropSize" select="$croppingSetup[@name = $crop]/@size"/>
				<xsl:variable name="selectedCrop" select="*/crops/crop[@name = $crop]"/>
				<xsl:if test="$selectedCrop">
					<xsl:attribute name="src"><xsl:value-of select="*/crops/crop[@name = $crop]/@url"/></xsl:attribute>
				</xsl:if>
				<!-- If a config file was created we can grab the cropped sizes from that -->
				<xsl:if test="$cropSize">
					<xsl:attribute name="width"><xsl:value-of select="substring-before($cropSize, 'x')"/></xsl:attribute>
					<xsl:attribute name="height"><xsl:value-of select="substring-after($cropSize, 'x')"/></xsl:attribute>
				</xsl:if>
				<!-- No config file - make sure to blank the dimensions inserted for the original image then -->
				<xsl:if test="not($cropSize)">
					<xsl:attribute name="width"/>
					<xsl:attribute name="height"/>
				</xsl:if>
			</xsl:if>
			<!-- $size can override original + cropped sizes -->
			<xsl:if test="$size">
				<xsl:attribute name="width"><xsl:value-of select="substring-before($size, 'x')"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="substring-after($size, 'x')"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$class"><xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute></xsl:if>
			<xsl:if test="$id"><xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute></xsl:if>
		</img>
	</xsl:template>
	
<!-- :: URL Templates :: -->
	<!-- Entry template -->
	<xsl:template match="*" mode="media.url">
		<xsl:param name="crop"/>
		<xsl:variable name="mediaNode" select="umb:GetMedia(., false())"/>
		<xsl:apply-templates select="$mediaNode[not(error)]" mode="url">
			<xsl:with-param name="crop" select="$crop"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Safeguards for empty elements - need one for each mode -->
	<xsl:template match="*[not(normalize-space())]" mode="media">
		<!-- Render info to the developer looking for clues in the source, as to why nothing renders -->
		<xsl:comment>Missing Media ID in <xsl:value-of select="name()"/> on <xsl:value-of select="../@nodeName"/> (ID: <xsl:value-of select="../@id"/>)</xsl:comment>
	</xsl:template>
	
	<xsl:template match="*[not(normalize-space())]" mode="media.url">
		<xsl:apply-templates select="." mode="media"/><!-- Redirect to the one above -->
	</xsl:template>
	
	<xsl:template match="*[not(normalize-space())]" mode="media.folder">
		<xsl:apply-templates select="." mode="media"/><!-- Redirect to the one above -->
	</xsl:template>
	
	<!-- Template for Images -->
	<xsl:template match="Image" mode="url">
		<xsl:param name="crop"/>
		<xsl:choose>
			<xsl:when test="$crop">
				<xsl:value-of select="*/crops/crop[@name = $crop]/@url"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umbracoFile"/>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>