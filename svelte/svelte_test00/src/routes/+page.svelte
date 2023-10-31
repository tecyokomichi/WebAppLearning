<script>
  import Nested from '../Nested.svelte';
  import PackageInfo from '../PackageInfo.svelte';

  const pkg = {
    name: 'svelte',
    speed: 'blazing',
    version: '4',
    website: 'https://svelte.dev'
  };

  let name = 'svelte';
  let src = 'images/svelte.png';
  let count = 0;
  let numbers = [1, 2, 3, 4];

  $: console.log(`the count is ${ count }`);
  $: {
    console.log(`the count is ${ count }`);
    console.log(`this will also be logged whenever count changes`);
  }
 /* $: if (count >= 10) {
    alert(`count is dangerously high!`);
    count = 0;
  } */

  $: doubled = count * 2;

  function increment() {
    count += 1;
  }

  function addNumber() {
    //numbers.push(numbers.length + 1);
    //numbers = numbers;
    numbers = [...numbers, numbers.length + 1];
  }

  $: sum = numbers.reduce((total, currentNumber) => total + currentNumber, 0);
</script>

<h1>Welcome to { name.toUpperCase() }</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
<Nested answer={ 42 } />
<Nested />
<!-- <PackageInfo
  name={ pkg.name }
  speed={ pkg.speed }
  version={ pkg.version }
  website={ pkg.website }
/> -->
<PackageInfo { ...pkg } />


<button on:click={ increment }>
  Clicked { count }
  { count === 1 ? 'time' : 'times' }
</button>

{#if count > 10}
  <p>{ count } is greater than 10</p>
{:else if count < 5}
  <p>{ count } is less than 5</p>
{:else}
  <p>{ count } is between 0 and 10</p>
{/if}

<button on:click={ addNumber }>
  Add a number
</button>

<p>{ count } doubled is { doubled }</p>

<p>{ numbers.join(' + ') } = { sum }</p>


<img { src } alt="{ name } dances." />

<style>
  p {
    color: goldenrod;
    font-family: 'Comic Sans MS', cursive;
    font-size: 2em;
  }
</style>
