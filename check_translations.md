# Check translations


Should be standalone webpage so JS can munch through translations.

User pastes xls content with columns, and we go through line by line.

We report discrepancies by line number and column.

There are 3 columns: qname, english, translated text.

Report if english field equals translated text field.

UI should be something like our new website.

Capturing these should be regexes with multiline spanning flag, case sensitive.

We want to ensure these parts didn't get touched at all during translations.

They can be moved inside the text field when it comes to position as in one language word can go somewhere else compared to english.



1. html elements: all the html elements supported by forsta platform from their guide on the website docs
1. pipe ` <title>[pipe: children_have] been to the zoo in the past 6 months?</title>`
1. python code `${python code}`
1. res elements [res Q1,resname]
1. res elements combined with html   `<case label="c1" cond="hasMarker('c1')"><img src="[rel concept_1.png]"/></case>`
1. res elements themselves `<res label="Concept_Image">[pipe: something]</res>`
1. res elements with html with image `<res label="Concept_Image"><img src="[rel concept_%s.png]"/></res>`
1. img elements
1. loopvar things such as: `[loopvar: something]`


For pipe check these options also to ensure they did not get translated:
1. upper	Upper-cases all letters of the pipe (e.g., PIPE TEXT LOOKS LIKE THIS)	[pipe: LABEL upper]
1. lower	Lower-cases all letters of the pipe (e.g., pipe text looks like this)	[pipe: LABEL lower]
1. title	Title-cases all letters of the pipe (e.g., Pipe Text Looks Like This)	[pipe: LABEL title]
1. capitalize	Capitalizes the first letter of the pipe (e.g., Pipe text looks like this)	[pipe: LABEL capitalize]


More stuff:
```xml
  <case label="c1" cond="hasMarker('concept_1')">
      <p>CONCEPT 1 TITLE</p>
      <p><img src="[rel concept_1.png]" class="concept"/></p>
  </case>
```
> **_HINT:_** 
What we can see above is that html takes precedence and if the whole html thing is good, then the rel part is also good.


```xml
<res label="concept_text">
  <p>CONCEPT {0} TITLE</p>
  <p><img src="[rel concept_{0}.png]" class="concept"/>
</p>
</res>
```


```xml
<html label="ShowConcept" where="survey">
   <p>Please take a look at the following concept.</p>
   <p>[pipe: concept]</p>
</html>
```

```xml
<res label="concept_text">
  <p>CONCEPT {0} TITLE</p>
  <p><img src="[rel concept_{0}.png]" class="concept"/>
</p>
</res>
```

## Testing

Go through all the xmls with translations, pull the xlates and there should be no errors reported.

