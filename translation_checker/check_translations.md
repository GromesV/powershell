# Check translations


Should be standalone webpage so JS can munch through translations.

User pastes xls content with columns, and we go through line by line.

We report discrepancies by line number and column.

There are 3 columns: qname, english, translated text.

Report if english field equals translated text field.

UI should be something like our new website.

Capturing these should be regexes with multiline spanning flag, case sensitive.

We want to ensure these parts didn't get touched at all during translations, even the white space must stay preserved.

They can be moved inside the text field when it comes to position as in one language word can go somewhere else compared to english.



1. html elements: all the html elements supported by forsta platform from their guide on the website docs, so div tag, p tag, bold, underline, anchor, italic for start
1. pipe ` <title>[pipe: children_have] been to the zoo in the past 6 months?</title>` so this part -> `[pipe: children_have]` should stay the same.
1. python code `${python code}` so this pattern should stay the same -> ${python code}
1. res elements `[res Q1,resname]` so this pattern should stay the same -> [res Q1,resname]
1. res elements combined with html   `<img src="[rel concept_1.png]"/>` so this part should stay the same -> `<img src="[rel concept_1.png]"/>`
1. res elements themselves `[pipe: something]` so this part should stay the same -> `[pipe: something]`
1. res elements with html with image `<img src="[rel concept_%s.png]"/>` so this part should stay the same -> `<img src="[rel concept_%s.png]"/>`
1. img macros `[rel concept_1.png]` so this part should stay the same -> `[rel concept_1.png]`
1. loopvar things such as: `[loopvar: something]` so this part should stay the same -> [loopvar: something]


For pipe check these options upper/lower/title/capitalize also to ensure they did not get translated:
1. upper	Upper-cases all letters of the pipe (e.g., PIPE TEXT LOOKS LIKE THIS)	`[pipe: LABEL upper]`
1. lower	Lower-cases all letters of the pipe (e.g., pipe text looks like this)	`[pipe: LABEL lower]`
1. title	Title-cases all letters of the pipe (e.g., Pipe Text Looks Like This)	`[pipe: LABEL title]`
1. capitalize	Capitalizes the first letter of the pipe (e.g., Pipe text looks like this)	`[pipe: LABEL capitalize]`


More stuff so only text inside these xml elements goes to translations:
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

