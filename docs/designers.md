# Docs

## Template engine

We're using [Liquid](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers) as Engine for build Emails Templates using HTML & CSS. Your teample will be a HTML content with some Liquid snippets inserted to display dynamic content. For example, in order to display the text of a mail, you would write {{ mail.text }}


## What does it look like?

```html
<style>
  h1 {color:red;}
  p {color:blue;}
</style>

<h1>Test Fixture</h1>
<p>{{mail.text}}</p

<a href="{{mail.link}}">
  <img src="{{mail.video_thumb}}"  alt="{{mail.video_name}}" />
</a>
```
