<script>
  import Nested from '../Nested.svelte';

  let name = 'svelte';
  let src = 'images/svelte.png';
</script>

<h1>Welcome to { name.toUpperCase() }</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
<Nested />


<img { src } alt="{ name } dances." />

<style>
  p {
    color: goldenrod;
    font-family: 'Comic Sans MS', cursive;
    font-size: 2em;
  }
</style>
