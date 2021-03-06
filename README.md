# Greystate XSLT Helpers

Miscellaneous XSLT files for use as included stylesheets to ease certain common tasks.

Hopefully, using these helpers you should be able to keep your XSLT clean and
readable, with a focus on the logic that's part of your app, not worrying too much about
the *common functionality* stuff that these provide.

## Installation

You can find installable packages for [Umbraco][UMBRACO] on the [releases][RELEASES] page, but if you prefer to install them manually, here's how:

* Grab `helpers` subfolder in the [`dist`][DIST] folder, and put it alongside your other XSLT files (i.e., in the `xslt` folder if you're using Umbraco).
* The files in the `config` folder should go into the `config` folder of your Umbraco installation.

## Basic usage

Using these helpers usually just require the same 2 steps:

1.	Include the file(s) in your main XSLT file using the include instruction:

	```xslt
	<xsl:include href="helpers/_HelperFile.xslt" />
	```

2.	Perform one of the following actions:
	
	1. Applying templates in a specific mode, e.g.:

		```xslt
		<xsl:apply-templates select="$currentPage/pageImage" mode="media" />
		```

	2. Calling a named template, e.g.:

		```xslt
		<xsl:call-template name="PaginateSelection" />
		```

## Helpers

Each helper has its own README but here&#8217;s a quick rundown: 

### [Pagination Helper][PAGINATION]

A self-contained clip-on solution for pagination of node-sets.

> "Just add Pagination"

### [MultiPicker Helper][MULTIPICKER]

Makes it very easy to work with various "picker" DataTypes in Umbraco, by having templates
for each of the possible content nodes, and then using a key to grab all the picked nodes.

### [Navigation Helper][NAVIGATION]

Simple Navigation generation - almost too easy. Supports the four most commonly needed navigations: Main navigation, Sub navigation, Breadcrumb and Sitemap.

### [Grouping Helper][GROUPING]

Just like pagination - but for grouping sets into chunks of *n* elements.

### [Calendar Helper][CALENDAR]

Easy as pie generation of that monthly calendar view you always need for your events/news section.
*Yes* to all of these:

> Can I use my own translations for the weekdays?

> Can I *please* have monday be the first day?

> Can I show events on the dates?


### [Media Helpers][MEDIA]

A bunch of well-tested templates for handling Media items in Umbraco - if you've asked some of the following questions, this is definitely for you:

> How can I output Media files and/or folders from my XSLT macros?

> But I just want to render the image the user picked - why is it so hard???

> How do I output a specific crop version?


[UMBRACO]: http://umbraco.com/
[RELEASES]: https://github.com/greystate/Greystate-XSLT-Helpers/releases/
[DIST]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/dist/
[PAGINATION]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/paginationhelper
[NAVIGATION]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/navigationhelper
[GROUPING]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/groupinghelper
[CALENDAR]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/calendarhelper
[MEDIA]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/mediahelpers
[MULTIPICKER]: https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/multipickerhelper
