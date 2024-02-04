<script context="module" lang="ts">
	import { Button } from "flowbite-svelte";

    type LoadParams = {
        params: {
            id: string;
        };
    };

    export async function load({ params }: LoadParams) {
        const { id } = params;
        return {
            props: {
                id
            }
        };
    }

    let formData = {
      branchCode: '',
      carCode: '',
      registWord: '',
      registDate: '',
      registFirdtDate: '',
      carKind: '',
      carPurpose: '',
      privateOrWork: '',
      carShape: '',
      carShapeCode: '',
      carMaker: '',
      carName: '',
      carGrade: '',
      carFrameNumber: '',
      car1Capacity: '',
      car2Capacity: '',
      car3Capacity: '',
      car1Carrying: '',
      car2Carrying: '',
      car3Carrying: '',
      car1Weight: '',
      car2Weight: '',
      car3Weight: '',
      car1TotalWeight: '',
      car2TotalWeight: '',
      car3TotalWeight: '',
      car1Length: '',
      car2Length: '',
      car1Width: '',
      car2Width: '',
      car1Height: '',
      car2Height: '',
      carFrontFrontWeight: '',
      carFrontRearWeight: '',
      carRearFrontWeight: '',
      carRearRearWeight: '',
      carModel: '',
      carEngineModel: '',
      displacement: '',
      carFuelKind: '',
      carModelWord: '',
      carClassification: '',
      dealerCode: '',
      customerCode: '',
      customerKanaCode: '',
      customerName: '',
      customerAddName: '',
      customerAddressCode: '',
      customerZipCode: '',
      customerAddress: '',
      customerAddAddress: '',
      customerPhone: '',
      customerMobilePhone: '',
      customerComment: '',
      userCode: '',
      userKanaCode: '',
      userName: '',
      userAddName: '',
      userAddressCode: '',
      userZipCode: '',
      userAddress: '',
      userAddAddress: '',
      userPhone: '',
      userMobilePhone: '',
      userComment: '',
      billingUserCode: '',
      billingUserKanaCode: '',
      billingUserName: '',
      billingUserAddName: '',
      billingUserAddressCode: '',
      billingUserZipCode: '',
      billingUserAdddress: '',
      billingUserAddAddress: '',
      billingUserPhone: '',
      billingUserMobilePhone: '',
      billingUserComment: '',
      useHomeArea: '',
      storingDate: '',
      inspectionDate: '',
      disposalDate: '',
      cycle: '',
      equipment: '',
      liabilityInsuranceKind: '',
      carGroup: '',
      carDiv: '',
      consumableInformationKind: '',
      laborRate: '',
      runDistance: '',
      estimateRunDistance: '',
      distanceAverage: '',
      insuranceCompanyName: '',
      insuranceNumber: '',
      recycleFee: '',
      comment1: '',
      comment2: '',
      comment3: '',
      comment4: '',
      wegithTaxAmount: '',
      insuranceAmount: '',
      stampFeeAmount: '',
      actCommitionAmount: '',
      taxAmount: '',
      addFee1Amount: '',
      addFee2Amount: '',
      addFee3Amount: '',
      addFee4Amount: '',
      feeTotalAmount: ''
    };

    let ary_data = [
      {key:0, name: "本店"},
      {key:1, name: "支店A"},
      {key:2, name: "支店B"},
    ];
    let sel = "";

    function handleSubmit() {
      // フォーム送信ロジック...
    }

</script>

<!--
<script lang="ts">
    export let id: string;
</script>

<svelte:head>
    <title>車両詳細</title>
</svelte:head>

<h1>車両詳細 - { id }</h1>
-->

<form on:submit|preventDefault={handleSubmit}>

  <div class="bg-glay-100 form-main">
    <div class="form-group" style="display: flex; border-top: none; border-left: none; border-right: none;">
      <p>部門 <span id="txt" >{ sel }</span></p>
      <select style="width: 10%;" bind:value={sel}>
        <option value="">選択</option>
        {#each ary_data as data}
        <option value={data.name} >{data.name}</option>
        {/each}
      </select>
    </div>
  
    <div class="form-group" style="none; border-left: none; border-right: none;">
      <label for="carCodeInput">車両コード</label>
      <input type="text" id="carCodeInput" bind:value={formData.carCode} size="5"/>
    </div>
  
    <div class="flex grid grid-cols-18 gap-0">
      <div class="form-group form-group-only-border-right col-span-4" style="text-align: center;">
        <label for="registWordInput" style="display: block;">自動車登録・車両番号</label>
        <input type="text" id="registWordInput" bind:value={formData.registWord} size="30"/>
      </div>
      <div class="form-group form-group-only-border-right col-span-2" style="text-align: center;">
        <label for="registDateInput" style="display: block; ">登録日</label>
        <input type="date" id="registDateInput" bind:value={formData.registDate}/>
      </div>
      <div class="form-group col-span-2" style="border-left: none; text-align: center;">
        <label for="registFirstDateInput" style="display: block; ">初度</label>
        <input type="date" id="registFirstDateInput" bind:value={formData.registFirdtDate}/>
      </div>
      <div class="form-group col-span-2" style="border-left: none; text-align: center;">
        <label for="carKindInput" style="display: block; ">種別</label>
        <select id="carKindInput" bind:value={formData.carKind} style="width: 100%;">
          <option value="">選択</option>
        </select>
      </div>
      <div class="form-group col-span-2" style="border-left: none; text-align: center;">
        <label for="carPurposeInput" style="display: block; ">用途</label>
        <select id="carPurposeInput" bind:value={formData.carPurpose} style="width: 100%;">
          <option value="">選択</option>
        </select>
      </div>
      <div class="form-group col-span-2" style="border-left: none; text-align: center;">
        <label for="privateOrWorkInput" style="display: block; ">自営別</label>
        <select id="privateOrWorkInput" bind:value={formData.privateOrWork} style="width: 100%;">
          <option value="">選択</option>
        </select>
      </div>
      <div class="form-group col-span-4" style="border-left: none; border-right: none;text-align: center;">
        <label for="carShapeInput" style="display: block; ">車体の形状</label>
        <input type="text" id="carShapeCodeInput" bind:value={formData.carShapeCode} size="5"/>
        <select id="carShapeInput" bind:value={formData.carShape} style="width: 50%;">
          <option value="">選択</option>
        </select>
        <Button>選択</Button>
      </div>
    </div>
  
    <div class="grid grid-cols-12 grid-rows-2 gap-0">
      <div class="form-group col-span-4 row-span-2" style="border-left: none;">
        <div style="display: flex; align-items: center;">
          <label for="carMakerInput" style="display: block; width: 80px">車名</label>
          <input type="text" id="carMakerInput" bind:value={formData.carMaker} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
        <div style="display: flex; align-items: center;">
          <label for="carNameInput" style="display: block; width: 80px">通称名</label>
          <input type="text" id="carNameInput" bind:value={formData.carName} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
      </div>
      <div class="form-group form-group-direction-column col-span-2 row-span-2 gap-1">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="carCapacity3Input" style="display: block; margin-right: 10px;">乗車定員</label>
          <input type="text" id="carCapacity3Input" bind:value={formData.car3Capacity} size="5"/>
        </div>
        <div style="text-align: center;">
          <input type="text" id="carCapacity1Input" bind:value={formData.car1Capacity} size="5"/>
          <input type="text" id="carCapacity2Input" bind:value={formData.car2Capacity} size="5"/>
        </div>
      </div>
      <div class="form-group form-group-direction-column col-span-2 row-span-2 gap-1" style="">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car3CarryingInput" style="display: block; margin-right: 16px;">最大積載量</label>
          <input type="text" id="car3CarryingInput" bind:value={formData.car3Carrying} size="8"/>
        </div>
        <div style="text-align: center;">
          <input type="text" id="car1CarryingInput" bind:value={formData.car1Carrying} size="8"/>
          <input type="text" id="car2CarryingInput" bind:value={formData.car2Carrying} size="8"/>
        </div>
      </div>
      <div class="form-group form-group-direction-column col-span-2 row-span-2 gap-1">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car3WeightInput" style="display: block; margin-right: 34px;">車両重量</label>
          <input type="text" id="car3WeightInput" bind:value={formData.car3Weight} size="8"/>
        </div>
        <div style="text-align: center;">
          <input type="text" id="car1WeightInput" bind:value={formData.car1Weight} size="8"/>
          <input type="text" id="car2WeightInput" bind:value={formData.car2Weight} size="8"/>
        </div>
      </div>
      <div class="form-group form-group-direction-column col-span-2 row-span-2 gap-1" style="border-left: none; border-right: none; display: flex;">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car3TotalWeightInput" style="display: block; margin-right: 22px;">車両総重量</label>
          <input type="text" id="car3TotalWeightInput" bind:value={formData.car3TotalWeight} size="8"/>
        </div>
        <div style="text-align: center;">
          <input type="text" id="car1TotalWeightInput" bind:value={formData.car1TotalWeight} size="8"/>
          <input type="text" id="car2TotalWeightInput" bind:value={formData.car2TotalWeight} size="8"/>
        </div>
      </div>
    </div>
  
    <div class="grid grid-cols-12 grid-rows-2 gap-0">
      <div class="form-group col-span-5 row-span-2 border-black" style="border-top: none; border-left: none;">
        <div style="display: flex; align-items: center;">
          <label for="carGradeInput" style="display: block; width: 80px">グレード</label>
          <input type="text" id="carGradeInput" bind:value={formData.carGrade} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
        
        <div style="display: flex; align-items: center;">
          <label for="carFrameNumberInput" style="display: block; width: 80px">車台番号</label>
          <input type="text" id="carFrameNumberInput" bind:value={formData.carFrameNumber} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
      </div>
      <div class="form-group col-span-1 row-span-2 gap-1" style="border-left: none; display: flex; flex-direction: column; justify-content: center; align-items: center;">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="carLength2Input" style="display: block; ">長さ</label>
          <input type="text" id="carLength2Input" bind:value={formData.car2Length} size="5"/>
        </div>
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="carLength1Input" style="display: block; visibility: hidden;">長さ</label>
          <input type="text" id="carLength1Input" bind:value={formData.car1Length} size="5"/>
        </div>
      </div>
      <div class="form-group col-span-1 row-span-2 gap-1" style="border-left: none; display: flex; flex-direction: column; justify-content: center; align-items: center;">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car2WidthInput" style="display: block; ">幅</label>
          <input type="text" id="car2WidthInput" bind:value={formData.car2Width} size="5"/>
        </div>
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car1WidthInput" style="display: block; visibility: hidden;">幅</label>
          <input type="text" id="car1WidthInput" bind:value={formData.car1Width} size="5"/>
        </div>
      </div>
      <div class="form-group col-span-1 row-span-2 gap-1" style="border-top: none; border-left: none; display: flex; flex-direction: column; justify-content: center; align-items: center;">
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car2HeightInput" style="display: block; ">高さ</label>
          <input type="text" id="car2HeightInput" bind:value={formData.car2Height} size="5"/>
        </div>
        <div style="display: flex; align-items: center; text-align: center;">
          <label for="car1HeightInput" style="display: block; visibility: hidden;">高さ</label>
          <input type="text" id="car1HeightInput" bind:value={formData.car1Height} size="5"/>
        </div>
      </div>
      <div class="form-group border col-span-1 row-span-2" style="padding: 5px; border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="carFrontFrontWeightInput" style="display: block; padding-top: 12px">前前軸重</label>
        <input type="text" id="carFrontFrontWeightInput" bind:value={formData.carFrontFrontWeight} size="10"/>
      </div>
      <div class="form-group border col-span-1 row-span-2" style="padding: 5px; border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="carFrontRearWeightInput" style="display: block; padding-top: 12px">前後軸重</label>
        <input type="text" id="carFrontRearWeightInput" bind:value={formData.carFrontRearWeight} size="10"/>
      </div>
      <div class="form-group border col-span-1 row-span-2" style="padding: 5px; border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="carRearFrontWeightInput" style="display: block; padding-top: 12px">後前軸重</label>
        <input type="text" id="carRearFrontWeightInput" bind:value={formData.carRearFrontWeight} size="10"/>
      </div>
      <div class="form-group border col-span-1 row-span-2" style="padding: 5px; border-top: none; border-left: none; border-right: none; align-items: center; text-align: center;">
        <label for="carRearRearWeightInput" style="display: block; padding-top: 12px">後後軸重</label>
        <input type="text" id="carRearRearWeightInput" bind:value={formData.carRearRearWeight} size="10"/>
      </div>
    </div>
  
    <div class="bg-green-100 flex grid grid-cols-12 gap-0">
      <div class="form-group border col-span-2" style=" border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="carModelInput" style="display: block;">型式</label>
        <input type="text" id="carModelInput" bind:value={formData.carModel} size="25"/>
      </div>
      <div class="form-group col-span-2" style="border-left: none; align-items: center; text-align: center;">
        <label for="carEngineModelInput" style="display: block;">原動機の型式</label>
        <input type="text" id="carEngineModelInput" bind:value={formData.carEngineModel} size="25"/>
      </div>
      <div class="form-group border col-span-2" style="padding: 5px; border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="displacementInput" style="display: block;">排気量又は定格出力</label>
        <input type="text" id="displacementInput" bind:value={formData.displacement} size="25"/>
      </div>
      <div class="form-group border col-span-2" style="padding: 5px; border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="carFuelKindInput" style="display: block;">燃料の種類</label>
        <select id="carFuelKindInput" bind:value={formData.carFuelKind} style="width: 100%;">
          <option value="">選択</option>
        </select>
      </div>
      <div class="form-group border col-span-2" style="padding: 5px; border-top: none; border-left: none; align-items: center; text-align: center;">
        <label for="carModelWordInput" style="display: block;">型式指定番号</label>
        <input type="text" id="carModelWordInput" bind:value={formData.carModelWord} size="10"/>
      </div>
      <div class="form-group border col-span-2" style="padding: 5px; border-top: none; border-left: none; border-right: none; align-items: center; text-align: center;">
        <label for="carClassificationInput" style="display: block;">類別区分番号</label>
        <input type="text" id="carClassificationInput" bind:value={formData.carClassification} size="10"/>
      </div>
    </div>
  
    <div class="flex grid grid-cols-12 grid-rows-4 gap-0">
      <div class="form-group col-span-1 row-span-4" style="border-top: none; border-left:none; border-right: none;">
        <div>所有者</div>
        <div style="display: flex; align-items: center;">
          <label for="dealerCodeInput" style="display: block; ">Dｺｰﾄﾞ</label>
          <input type="text" id="dealerCodeInput" bind:value={formData.dealerCode} style="argin-top: 5px;" size="5"/>
        </div>
      </div>
      <div class="form-group col-span-6 row-span-4" style="border-top: none; border-left:none; border-right: none;">
        <div style="display: grid; grid-template-columns: auto 1fr 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <div>
            <label for="customerCodeInput" style="width: 50px; margin-right: 10px;">コード</label>
            <input type="text" id="customerCodeInput" bind:value={formData.customerCode} size="5"/>
          </div>
          <div>
            <label for="customerKanaCodeInput" style="width: 50px; margin-right: 10px;">カナコード</label>
            <input type="text" id="customerKanaCodeInput" bind:value={formData.customerKanaCode} style="width: 50%;"/>
          </div>
          <div style="display: flex; justify-content: flex-end; align-items: center;">
            <label for="customerPhoneInput" style="width: 50px; margin-right: 10px;">TEL</label>
            <input type="text" id="customerPhoneInput" bind:value={formData.customerPhone}/>
          </div>
        </div>
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <label for="customerNameInput" style="width: 50px; margin-right: 10px;">名称</label>
          <input type="text" id="customerNameInput" bind:value={formData.customerName} size="10"/>
        </div>
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <div>
            <label for="customerZipCodeInput" style="margin-right: 45px;">〒</label>
            <input type="text" id="customerZipCodeInput" bind:value={formData.customerZipCode} size="10"/>
          </div>
          <div>
            <label for="customerAddressInput" style="width: 50px; margin-right: 10px;">住所</label>
            <input type="text" id="customerAddressInput" bind:value={formData.customerAddress} style="width: 92%">
          </div>         
        </div>
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <label for="customerCommentInput" style="width: 50px; margin-right: 10px;">備考</label>
          <input type="text" id="customerCommentInput" bind:value={formData.customerComment}/>
        </div>
      </div>
      <div class="form-group col-span-5 row-span-4" style="border-top: none; border-left:none; border-right: none;">
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <div>
            <label for="customerMobilePhoneInput" style="width: 50px; margin-right: 10px;">携帯</label>
            <input type="text" id="customerMobilePhoneInput" bind:value={formData.customerMobilePhone}/>
          </div>
          <div style="display: flex; justify-content: flex-end; align-items: center;">
            <label for="customerAddressCodeInput">住所コード</label>
            <input type="text" id="customerAddressCodeInput" bind:value={formData.customerAddressCode}/>
          </div>
        </div>
        <div>
          <input type="text" id="customerAddNameInput" bind:value={formData.customerAddName} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
        <div>
          <input type="text" id="customerAddAddressInput" bind:value={formData.customerAddAddress} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
      </div>
    </div>
  
    <div class="flex grid grid-cols-12 grid-rows-4 gap-0">
      <div class="form-group col-span-1 row-span-4" style="border-top: none; border-left:none; border-right: none;">
        <div>使用者</div>
        <div style="display: none;">
          <label for="dummyInput" style="display: block; ">ダミー</label>
          <input type="text" id="dummyInput"/>
        </div>
      </div>
      <div class="form-group col-span-6 row-span-4" style="border-top: none; border-left:none; border-right: none;">
        <div style="display: grid; grid-template-columns: auto 1fr 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <div>
            <label for="userCodeInput" style="width: 50px; margin-right: 10px;">コード</label>
            <input type="text" id="userCodeInput" bind:value={formData.userCode} size="5"/>
          </div>
          <div>
            <label for="userKanaCodeInput" style="width: 50px; margin-right: 10px;">カナコード</label>
            <input type="text" id="userKanaCodeInput" bind:value={formData.userKanaCode} style="width: 50%;"/>
          </div>
          <div style="display: flex; justify-content: flex-end; align-items: center;">
            <label for="userPhoneInput" style="width: 50px; margin-right: 10px;">TEL</label>
            <input type="text" id="userPhoneInput" bind:value={formData.userPhone}/>
          </div>
        </div>
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <label for="userNameInput" style="width: 50px; margin-right: 10px;">名称</label>
          <input type="text" id="userNameInput" bind:value={formData.userName}/>
        </div>
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <div>
            <label for="userZipCodeInput" style="margin-right: 45px;">〒</label>
            <input type="text" id="userZipCodeInput" bind:value={formData.userZipCode} size="10"/>
          </div>
          <div>
            <label for="userAddressInput" style="width: 50px; margin-right: 10px;">住所</label>
            <input type="text" id="userAddressInput" bind:value={formData.userAddress} style="width: 92%">
          </div>         
        </div>
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <label for="userCommentInput" style="width: 50px; margin-right: 10px;">備考</label>
          <input type="text" id="userCommentInput" bind:value={formData.userComment}/>
        </div>
      </div>
      <div class="form-group col-span-5 row-span-4" style="border-top: none; border-left:none; border-right: none;">
        <div style="display: grid; grid-template-columns: auto 1fr; gap: 5px; align-items: center; margin-bottom: 5px;">
          <div>
            <label for="userMobilePhoneInput" style="width: 50px; margin-right: 10px;">携帯</label>
            <input type="text" id="userMobilePhoneInput" bind:value={formData.userMobilePhone}/>
          </div>
          <div style="display: flex; justify-content: flex-end; align-items: center;">
            <label for="userAddressCodeInput">住所コード</label>
            <input type="text" id="userAddressCodeInput" bind:value={formData.userAddressCode}/>
          </div>
        </div>
        <div>
          <input type="text" id="userAddNameInput" bind:value={formData.userAddName} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
        <div>
          <input type="text" id="userAddAddress" bind:value={formData.userAddAddress} style="width: 100%; display: block; margin-top: 5px;" />
        </div>
      </div>
    </div>
  
    <div class="grid grid-cols-12 gap-0">
      <div class="form-group col-span-6 border-black" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="useHomeAreaInput" style="display: block; width: 180px">使用の本拠の位置</label>
        <input type="text" id="useHomeAreaInput" bind:value={formData.useHomeArea} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
      <div class="form-group col-span-2 border-black" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="storingDateInput" style="display: block; width: 140px">最終売上日</label>
        <input type="date" id="storingDateInput" bind:value={formData.storingDate}/>
      </div>
      <div class="form-group col-span-2 border-black" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="carGroupInput" style="display: block; width: 140px">グループ</label>
        <input type="text" id="carGroupInput" bind:value={formData.carGroup} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
      <div class="form-group col-span-2 border-black" style="display: flex; border-top: none; border-left: none; border-right: none; align-items: center;">
        <label for="consumableInformationKindInput" style="display: block; width: 140px">消耗部品</label>
        <input type="text" id="consumableInformationKindInput" bind:value={formData.consumableInformationKind} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
    </div>
  
    <div class="grid grid-cols-12 gap-0">
      <div class="form-group col-span-3" style="display: flex; border: 1px solid #000; padding: 5px; border-top: none; border-left: none; align-items: center;">
        <label for="inspectionDateInput" style="display: block; ">車検満了日</label>
        <input type="date" id="inspectionDateInput" bind:value={formData.inspectionDate} style="margin-top: 5px;" />
      </div>
      <div class="form-group col-span-1" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="cycleInput" style="display: block; width: 200px">サイクル</label>
        <input type="text" id="cycleInput" bind:value={formData.cycle} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
      <div class="form-group col-span-2" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="equipmentInput" style="display: block; width: 50px">装備</label>
        <input type="text" id="equipmentInput" bind:value={formData.equipment} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
      <div class="form-group col-span-2" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="liabilityInsuranceKindInput" style="display: block; width: 140px">自賠責区分</label>
        <input type="text" id="liabilityInsuranceKindInput" bind:value={formData.liabilityInsuranceKind} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
      <div class="form-group col-span-2" style="display: flex; border-top: none; border-left: none; align-items: center;">
        <label for="carDivInput" style="display: block; width: 140px">車種</label>
        <input type="text" id="carDivInput" bind:value={formData.carDiv} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
      <div class="form-group col-span-2" style="display: flex; border-top: none; border-left: none; border-right: none; align-items: center;">
        <label for="laborRateInput" style="display: block; width: 140px">レバレート</label>
        <input type="text" id="laborRateInput" bind:value={formData.laborRate} style="width: 100%; display: block; margin-top: 5px;" />
      </div>
    </div>
  
    <div class="grid grid-cols-12 grid-rows-5 gap-0">
      <div class="col-span-3 row-span-5">
        <div class="form-group" style="display: flex;gap: 3px; align-items: center; border-top: none; border-left: none;">
          <label for="runDistanceInput" style="display: block; ">走行距離 (km)</label>
          <input type="text" id="runDistanceInput" bind:value={formData.runDistance}/>
        </div>
        <div class="form-group" style="display: flex; padding: 5px; gap: 3px; border-top: none; border-left: none; border-bottom: none; align-items: center;">
          <label for="insuranceCompanyNameInput" style="display: block; ">保険会社</label>
          <input type="text" id="insuranceCompanyNameInput" bind:value={formData.insuranceCompanyName}/>
          <Button>読込</Button>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; border-top: none; border-left: none; align-items: center;">
          <label for="insuranceNumberInput" style="display: block; ">証券番号</label>
          <input type="text" id="insuranceNumberInput" bind:value={formData.insuranceNumber}/>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; align-items: center; border-top: none; border-left: none;">
          <label for="recycleFeeInput" style="display: block; ">リサイクル預託金</label>
          <input type="text" id="recycleFeeInput" bind:value={formData.recycleFee}/>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; align-items: center; border-top: none; border-left: none; border-bottom: none;">
          <label for="disposalDateInput" style="display: block; ">廃車日</label>
          <input type="date" id="disposalDateInput" bind:value={formData.disposalDate}/>
        </div>
      </div>
      <div class="col-span-4 row-span-5">
        <div class="form-group" style="display: flex; gap: 3px; align-items: center; border-top: none; border-left: none; border-bottom: none;">
          <label for="comment1Input" style="display: block; width: 60px">備考</label>
          <input type="text" id="comment1Input" bind:value={formData.comment1} style="width: 100%;"/>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; align-items: center; border-top: none; border-left: none; border-bottom: none;">
          <label for="comment2Input" style="display: block; width: 60px">備考</label>
          <input type="text" id="comment2Input" bind:value={formData.comment2} style="width: 100%;"/>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; align-items: center; border-top: none; border-left: none; border-bottom: none;">
          <label for="comment3Input" style="display: block; width: 60px">車検証</label>
          <input type="text" id="comment3Input" bind:value={formData.comment3} style="width: 100%;"/>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; align-items: center; border-top: none; border-left: none;">
          <label for="comment4Input" style="display: block; width: 60px">備考</label>
          <input type="text" id="comment4Input" bind:value={formData.comment4} style="width: 100%;"/>
        </div>
        <div class="form-group" style="display: flex; gap: 3px; border-left: none; border-bottom: none; align-items: center;">
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; width: 50%;">
            <label for="estimateRunDistanceInput" style="display: block; width:200px">現在推定距離</label>
            <input type="text" id="estimateRunDistanceInput" bind:value={formData.estimateRunDistance} style="width: 100%;"/>
          </div>
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center;">
            <label for="distanceAverageInput" style="display: block; width:200px">月平均距離</label>
            <input type="text" id="distanceAverageInput" bind:value={formData.distanceAverage} style="width: 100%;"/>
          </div>
        </div>
      </div>
      <div class="col-span-5 row-span-5 gap-0">
        <div style="display: flex; gap: 3px; align-items: center;">
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; width: 50%;">
            <label for="wegithTaxAmountInput" style="display: block; width:65px">重量税</label>
            <Button>料金表</Button>
            <input type="text" id="wegithTaxAmountInput" bind:value={formData.wegithTaxAmount} size="10"/>
          </div>
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center;">
            <label for="addFee1AmountInput" style="display: block; width:150px">自動車審査証紙代</label>
            <input type="text" id="addFee1AmountInput" bind:value={formData.addFee1Amount} size="10"/>
          </div>
        </div>
        <div style="display: flex; gap: 3px; align-items: center;">
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; width: 50%;">
            <label for="insuranceAmountInput" style="display: block; width:65px">保険料</label>
            <Button>料金表</Button>
            <input type="text" id="insuranceAmountInput" bind:value={formData.insuranceAmount} size="10"/>
          </div>
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; border-top: none; border-left: none; border-right: none;">
            <label for="addFee2AmountInput" style="display: block; width:150px"></label>
            <input type="text" id="addFee2AmountInput" bind:value={formData.addFee2Amount} size="10"/>
          </div>
        </div>
        <div style="display: flex; gap: 3px; align-items: center;">
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; width: 50%;">
            <label for="stampFeeAmountInput" style="display: block; width:150px">印紙代</label>
            <input type="text" id="stampFeeAmountInput" bind:value={formData.stampFeeAmount} size="10"/>
          </div>
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center;">
            <label for="addFee3AmountInput" style="display: block; width:150px"></label>
            <input type="text" id="addFee3AmountInput" bind:value={formData.addFee3Amount} size="10"/>
          </div>
        </div>
        <div style="display: flex; gap: 3px; align-items: center;">
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; width: 50%;">
            <label for="actCommitionAmountInput" style="display: block; width:150px">車検手続料</label>
            <input type="text" id="actCommitionAmountInput" bind:value={formData.actCommitionAmount} size="10"/>
          </div>
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center;">
            <label for="addFee4AmountInput" style="display: block; width:150px"></label>
            <input type="text" id="addFee4AmountInput" bind:value={formData.addFee4Amount} size="10"/>
          </div>
        </div>
        <div style="display: flex; gap: 3px; align-items: center;">
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center; width: 50%;">
            <label for="taxAmountInput" style="display: block; width:150px">消費税</label>
            <input type="text" id="taxAmountInput" bind:value={formData.taxAmount} size="10"/>
          </div>
          <div style="display: flex; padding: 5px; gap: 3px; align-items: center;">
            <label for="feeTotalAmountInput" style="display: block; width:150px">諸費用合計</label>
            <input type="text" id="feeTotalAmountInput" bind:value={formData.feeTotalAmount} size="10"/>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div style="text-align: right;">
    <button type="submit">送信</button>
  </div>
</form>

<style>
  button {
    background-color: #4CAF50; /* Green */
    border: none;
    color: white;
    padding: 5px 10px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 18px;
    margin: 4px 2px;
    cursor: pointer;
  }

  .form-group + .form-group {
    border-top: none;
  }
</style>
