<script>
    import { Button, Table, TableBody, TableBodyCell, TableHead, TableHeadCell } from 'flowbite-svelte';

    import { car } from './car.js';

</script>

<svelte:head>
    <title>車両</title>
</svelte:head>

<Button>デフォルトボタン</Button>

<Table class="w-full">
    <TableHead>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >コード</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >車両登録番号</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >得意先名</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >登録日</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >初度</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >車検日</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >前入庫日</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >車名</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >通称名</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" >型式</TableHeadCell>
      <TableHeadCell class="border border-2 border-green-500 px-6 py-3" ></TableHeadCell>
    </TableHead>
    <TableBody>
        {#each car as item, i (item.id)}
            <tr>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.code}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.registword}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.customerName}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.regsitDate}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.regsitFirstDate}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.inspectionDate}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.storingDate}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.carMaker}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.carName}</TableBodyCell>
                <TableBodyCell class="border border-2 border-green-500 px-6 py-3">{item.carModel}</TableBodyCell>
            </tr>
        {/each}
    </TableBody>
  </Table>
