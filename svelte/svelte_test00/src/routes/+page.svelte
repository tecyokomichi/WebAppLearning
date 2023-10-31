<script>
  import Nested from '../Nested.svelte';

  let name = 'svelte';
  let src = 'images/svelte.png';
  let count = 0;

  function increment() {
    count += 1;
  }
</script>

<h1>Welcome to { name.toUpperCase() }</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
<Nested />

<button on:click={ increment }>
  Clicked { count }
  { count === 1 ? 'time' : 'times' }
</button>


<img { src } alt="{ name } dances." />

<style>
  p {
    color: goldenrod;
    font-family: 'Comic Sans MS', cursive;
    font-size: 2em;
  }
</style>
