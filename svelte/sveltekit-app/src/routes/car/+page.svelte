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
      <TableHeadCell class="table-header-cell" >コード</TableHeadCell>
      <TableHeadCell class="table-header-cell" >車両登録番号</TableHeadCell>
      <TableHeadCell class="table-header-cell" >得意先名</TableHeadCell>
      <TableHeadCell class="table-header-cell" >登録日</TableHeadCell>
      <TableHeadCell class="table-header-cell" >初度</TableHeadCell>
      <TableHeadCell class="table-header-cell" >車検日</TableHeadCell>
      <TableHeadCell class="table-header-cell" >前入庫日</TableHeadCell>
      <TableHeadCell class="table-header-cell" >車名</TableHeadCell>
      <TableHeadCell class="table-header-cell" >通称名</TableHeadCell>
      <TableHeadCell class="table-header-cell" >型式</TableHeadCell>
    </TableHead>
    <TableBody>
        {#each car as item, i (item.id)}
            <tr>
                <TableBodyCell class="table-body-cell">{item.code}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.registword}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.customerName}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.regsitDate}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.regsitFirstDate}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.inspectionDate}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.storingDate}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.carMaker}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.carName}</TableBodyCell>
                <TableBodyCell class="table-body-cell">{item.carModel}</TableBodyCell>
            </tr>
        {/each}
    </TableBody>
</Table>

<style>
	:global(.table-header-cell)  {
        border: 2px solid green;
        padding: 12px;
    }
    :global(.table-body-cell)  {
        border: 2px solid green;
        padding: 12px;
    }
</style>
