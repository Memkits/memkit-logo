
w = innerWidth
h = innerHeight

init = ->
  renderer = new THREE.WebGLRenderer antialias: yes
  renderer.setClearColor 0xffffff
  renderer.setSize w, h
  document.body.appendChild renderer.domElement

  scene = new THREE.Scene

  camera = new THREE.PerspectiveCamera 70, w/h, 1, 2000
  camera.position.x = 20
  camera.position.y = 30
  camera.position.z = 70
  camera.lookAt scene.position

  light = new THREE.SpotLight 0xffffff, 1, 1000
  light.position.set 30, 40, 30
  scene.add light

  group = new THREE.Object3D

  material = new THREE.MeshLambertMaterial
    color: 0xaaaaff
    emissive: 0x9999ee
    wireframe: no

  d = 10
  r = 2

  d2 = 2 * d
  d3r = 3 * d + r
  d4 = 4 * d + 4 * r
  r2 = 2 * r
  dr = d + r

  # lm = new THREE.MeshBasicMaterial color: 0xaaaa22
  # lm.opacity = 0.1
  # geometry = new THREE.BoxGeometry d2, d2, d2
  # group.add (new THREE.Mesh geometry, lm)

  l1 = new THREE.BoxGeometry r2, r2, d4
  o1 = new THREE.Mesh l1, material
  o1.position.x = 0
  o1.position.y = dr
  o1.position.z = -d
  group.add o1

  l2 = new THREE.BoxGeometry r2, r2, d4
  o2 = new THREE.Mesh l2, material
  o2.position.x = dr
  o2.position.y = 0
  o2.position.z = d
  group.add o2

  l3 = new THREE.BoxGeometry d4, r2, r2
  o3 = new THREE.Mesh l3, material
  o3.position.x = d
  o3.position.z = 0
  o3.position.y = -dr
  group.add o3

  l4 = new THREE.BoxGeometry d4, r2, r2
  o4 = new THREE.Mesh l4, material
  o4.position.x = -d
  o4.position.y = 0
  o4.position.z = -dr
  group.add o4

  l5 = new THREE.BoxGeometry r2, d4, r2
  o5 = new THREE.Mesh l5, material
  o5.position.x = 0
  o5.position.y = -d
  o5.position.z = dr
  group.add o5

  l6 = new THREE.BoxGeometry r2, d4, r2
  o6 = new THREE.Mesh l6, material
  o6.position.x = -dr
  o6.position.y = d
  o6.position.z = 0
  group.add o6

  scene.add group

  renderer.render scene, camera

  cache = {}
  document.onmousedown = (event) ->
    cache.active = yes
    cache.x = event.x
    cache.y = event.y
  document.onmousemove = (event) ->
    if cache.active
      group.rotation.x += (event.x - cache.x) / 100
      group.rotation.y += (event.y - cache.y) / 100
      cache.x = event.x
      cache.y = event.y
      renderer.render scene, camera

  document.onmouseup = (event) ->
    cache.active = no

animate = ->
  render()
  setTimeou ->
    requestAnimationFrame animate
  , 1000

init()