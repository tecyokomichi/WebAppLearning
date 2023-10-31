<script>
  import Nested from '../Nested.svelte';

  let name = 'svelte';
  let src = 'images/svelte.png';
  let count = 0;
  let numbers = [1, 2, 3, 4];

  $: console.log(`the count is ${ count }`);
  $: {
    console.log(`the count is ${ count }`);
    console.log(`this will also be logged whenever count changes`);
  }
  $: if (count >= 10) {
    alert(`count is dangerously high!`);
    count = 0;
  }

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
<Nested />

<button on:click={ increment }>
  Clicked { count }
  { count === 1 ? 'time' : 'times' }
</button>

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
