<script>
  let string = 'this string contains some <strong>HTML!!!</strong>'
  export let answer;
</script>

<p>{ @html string }</p>
<p>The answer is { answer }</p>