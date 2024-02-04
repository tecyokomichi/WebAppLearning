export type Car = {
    id: number;
    code: string;
    registword: string;
    regsitDate: string;
    customerName: string;
    regsitFirstDate: string;
    inspectionDate: string;
    storingDate: string;
    carMaker: string;
    carName: string;
    carModel: string;
};

export const car: Car[] = [
    { id: 1, code: '1001', registword: '那須　　303み1111', regsitDate: 'H26.01.11', customerName: '斉藤 大介 ', regsitFirstDate: 'H26.01', inspectionDate: 'R7.11.12', storingDate: 'R05.06.06', carMaker: '日産', carName: 'スカイライン', carModel: '*****1' },
    { id: 2, code: '1002', registword: '宇都宮 111あみ  22', regsitDate: 'H27.02.12', customerName: 'ほげほげ産業', regsitFirstDate: 'H27.02', inspectionDate: 'R8.12.13', storingDate: 'R06.07.07', carMaker: '日産', carName: 'キャラバン', carModel: '*****2' },
    { id: 3, code: '1003', registword: '那須 　103い   3', regsitDate: 'H28.03.13', customerName: '木下 秀夫', regsitFirstDate: 'H28.03', inspectionDate: 'R9.13.14', storingDate: 'R07.08.08', carMaker: 'トヨタ', carName: '86', carModel: '*****3' },
    { id: 4, code: '1004', registword: '那須　　104み4444', regsitDate: 'H29.04.14', customerName: '佐々木 洋一郎', regsitFirstDate: 'H29.04', inspectionDate: 'R10.14.15', storingDate: 'R08.09.09', carMaker: 'マツダ', carName: 'MAZDA2', carModel: '*****4' },
    { id: 5, code: '1005', registword: '宇都宮 105か 555', regsitDate: 'H30.05.15', customerName: '狩野 ただお', regsitFirstDate: 'H30.05', inspectionDate: 'R11.15.16', storingDate: 'R09.010.010', carMaker: 'ホンダ', carName: 'オデッセイ', carModel: '*****5' },
    { id: 6, code: '1006', registword: '宇都宮 106さ6996', regsitDate: 'H31.06.16', customerName: '井尻 こうすけ', regsitFirstDate: 'H31.06', inspectionDate: 'R12.16.17', storingDate: 'R010.011.011', carMaker: 'スバル', carName: 'X-TRAIL', carModel: '*****6' },
    { id: 7, code: '1007', registword: '栃木　　107そ7777', regsitDate: 'H32.07.17', customerName: '安藤　まゆ', regsitFirstDate: 'H32.07', inspectionDate: 'R13.17.18', storingDate: 'R011.012.012', carMaker: '三菱', carName: 'ギャラン', carModel: '*****7' },
    { id: 8, code: '1008', registword: '宇都宮 108ち   8', regsitDate: 'H33.08.18', customerName: '小出 康成', regsitFirstDate: 'H33.08', inspectionDate: 'R14.18.19', storingDate: 'R012.013.013', carMaker: '日産', carName: 'ジューク', carModel: '*****8' },
    { id: 9, code: '1009', registword: '那須　　109ゆ  99', regsitDate: 'H34.09.19', customerName: '君島 十和子', regsitFirstDate: 'H34.09', inspectionDate: 'R15.19.110', storingDate: 'R013.014.014', carMaker: 'トヨタ', carName: 'アリスト', carModel: '*****9' },
]
