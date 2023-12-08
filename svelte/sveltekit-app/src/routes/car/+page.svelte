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
      <TableHeadCell >コード</TableHeadCell>
      <TableHeadCell >車両登録番号</TableHeadCell>
      <TableHeadCell >得意先名</TableHeadCell>
      <TableHeadCell >登録日</TableHeadCell>
      <TableHeadCell >初度</TableHeadCell>
      <TableHeadCell >車検日</TableHeadCell>
      <TableHeadCell >前入庫日</TableHeadCell>
      <TableHeadCell >車名</TableHeadCell>
      <TableHeadCell >通称名</TableHeadCell>
      <TableHeadCell >型式</TableHeadCell>
      <TableHeadCell ></TableHeadCell>
    </TableHead>
    <TableBody>
        {#each car as item, i (item.id)}
            <tr>
                <TableBodyCell>{item.code}</TableBodyCell>
                <TableBodyCell>{item.registword}</TableBodyCell>
                <TableBodyCell>{item.customerName}</TableBodyCell>
                <TableBodyCell>{item.regsitDate}</TableBodyCell>
                <TableBodyCell>{item.regsitFirstDate}</TableBodyCell>
                <TableBodyCell>{item.inspectionDate}</TableBodyCell>
                <TableBodyCell>{item.storingDate}</TableBodyCell>
                <TableBodyCell>{item.carMaker}</TableBodyCell>
                <TableBodyCell>{item.carName}</TableBodyCell>
                <TableBodyCell>{item.carModel}</TableBodyCell>
            </tr>
        {/each}
    </TableBody>
  </Table>
