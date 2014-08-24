doctype

html
  head
    title Memkits Logo
    meta (:charset utf-8)
    link (:rel stylesheet) (:href css/style.css)
    @if (@ dev)
      @block
        script (:src bower_components/three.js/three.min.js)
        script (:defer) (:src build/main.js)
      @block
        script (:src http://cdn.staticfile.org/three.js/r67/three.min.js)
        script (:defer) (:src build/main.min.js)
  body