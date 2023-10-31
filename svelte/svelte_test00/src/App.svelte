<script>
  import Thing from './Thing.svelte';
  import { getRandomNumber } from './utils.js';
  import Outer from './Outer.svelte';
  import BigRedButton from './BigRedButton.svelte';
  import horn from './horn.mp3';
  import { onMount } from 'svelte';
	const colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet'];
	let selected = colors[0];
  let things = [
		{ id: 1, name: 'apple' },
		{ id: 2, name: 'banana' },
		{ id: 3, name: 'carrot' },
		{ id: 4, name: 'doughnut' },
		{ id: 5, name: 'egg' }
	];
  let promise = getRandomNumber();
  let m = { x: 0, y: 0 };
  let audio;
  let name = 'color';
  let a = 1;
  let b = 2;

  onMount(() => {
    audio = new Audio();
    audio.src = horn;
  });

	function handleClick() {
		things = things.slice(1);
	}

  function handleClickAwait() {
		promise = getRandomNumber();
	}

  function handleMessage(event) {
    alert(event.detail.text);
  }

  function handleClickAudio() {
    audio.play();
  }

</script>

<h1 style="color: {selected}">Pick a colour {name}</h1>

<div>
	{#each colors as color, i}
    <button
      aria-current={ selected === color }
      aria-label={ color }
      style="background: { color };"
      on:click={ () => selected = color }
    >{ i + 1 }</button>
  {/each}
</div>

<button on:click={ handleClick }>
	Remove first thing
</button>

{#each things as thing (thing.id)}
	<Thing name={ thing.name } />
{/each}

<button on:click={handleClickAwait}>
	generate random number
</button>
{#await promise}
  <p>...waiting</p>
{:then number}
  <p>The number is {number}</p>
{:catch error}
  <p style="color: red">{error.message}</p>
{/await}

<div style="width: 100%; height: 100%; padding: 1em" on:pointermove={(e) => {
  m = { x: e.clientX, y: e.clientY };
}}>
  The pointer is at {m.x} {m.y}
</div>

<button on:click|once={() => alert('clicked')}>
  Click me
</button>

<Outer on:message={handleMessage}/>

<BigRedButton on:click={handleClickAudio} />

<input bind:value="{name}" />

<label>
	<input type="number" bind:value={a} min="0" max="10" />
	<input type="range" bind:value={a} min="0" max="10" />
</label>

<label>
	<input type="number" bind:value={b} min="0" max="10" />
	<input type="range" bind:value={b} min="0" max="10" />
</label>

<p>{a} + {b} = {a + b}</p>

<style>
	h1 {
		transition: color 0.2s;
	}

	div {
		display: grid;
		grid-template-columns: repeat(7, 1fr);
		grid-gap: 5px;
		max-width: 400px;
	}

	button {
		aspect-ratio: 1;
		border-radius: 50%;
		background: var(--color, #fff);
		transform: translate(-2px,-2px);
		filter: drop-shadow(2px 2px 3px rgba(0,0,0,0.2));
		transition: all 0.1s;
	}

	button[aria-current="true"] {
		transform: none;
		filter: none;
		box-shadow: inset 3px 3px 4px rgba(0,0,0,0.2);
	}
</style>