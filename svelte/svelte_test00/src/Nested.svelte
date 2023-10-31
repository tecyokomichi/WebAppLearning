<script>
  let string = 'this string contains some <strong>HTML!!!</strong>'
  export let answer = 'a mystery';
</script>

<p>{ @html string }</p>
<p>The answer is { answer }</p>