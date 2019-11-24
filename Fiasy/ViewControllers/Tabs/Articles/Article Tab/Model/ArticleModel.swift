//
//  ArticleModel.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

struct ArticleModel {
    
    var id: Int = 0
    var name: String = ""
    var title: String = ""
    var premium: Bool = false
    var text: NSAttributedString?
    var attributedTitle: NSAttributedString?
    var filter: String = ""
    var image = UIImage()
    var alphaViewColor: UIColor = .clear
    var description: NSMutableAttributedString?
    
    static func fetchAllArticleModels() -> [[ArticleModel]] {
        var nutritionModels: [ArticleModel] = []
        var trainingModels: [ArticleModel] = []
//        for index in 0...15 {
//            
//            var model = ArticleModel()
//            model.id = index
//            switch index {
//            case 0:
//                model.image = #imageLiteral(resourceName: "6")
//                model.name = "Ушли по–английски: 5 огненных кардио против лишнего веса"
//                model.title = "Что делать, если бегать стало скучно?  Борьба с килограммами и пробегающие неподалеку спортсмены прекрасно мотивируют, но хочется разнообразия."
//                model.alphaViewColor = #colorLiteral(red: 0.1121352091, green: 0.2944871187, blue: 0.3077611923, alpha: 1)
//                model.category = .training
//                model.premium = false
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                mutableAttrString.append(NSAttributedString(string: "Мы собрали для вас альтернативные варианты кардионагрузок, которые принесут не только пользу, но и удовольствие.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "1. Аквааэробика\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Тренировки бережно задействуют суставы и мышцы, равномерно нагружают позвоночник. После нескольких занятий уменьшается тревожность, уходит депрессия, улучшается кровообращение. Масса бонусов, не так ли?\nЗа час занятий вы потеряете ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "680–700 калорий.\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. Зумба\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Зажигательные латиноамериканские мотивы и ритмичные покачивания бедрами в такт музыке не оставят вас равнодушными.\n\nПродолжительность занятия от 50 минут до часа. За тренировку вы потеряете до ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "500 калорий. ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "На замену им вы получаете мощный заряд адреналина, уверенность в своих силах и новые танцевальные треки для плейлиста!\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Большой теннис\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Особенное удовольствие поиграть в компании друзей, снять напряжение и зарядиться энергией. За час игры сжигается около ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "400 калорий.\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4. Ходьба по лестнице\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Представьте: на улице льет дождь, а у вас время для занятий спортом. Оставим пробежки под дождем романтикам, а сами найдем наиболее доступную кардиотренировку.\n\nВо время ходьбы частота сердечных ритмов составляет 150 ударов в минуту. За счет интенсивного дыхания в тканях увеличивается кислород, и происходит активное сжигание жира.\n\nХодьба укрепляет мышцы ягодиц и ног. А если выполнять подъемы на носочках, то подключатся еще и икроножные мышцы. За 20 минут ходьбы мы теряем ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "500–700 калорий.\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5. Прыжки со скакалкой\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Прыжки могут быть очень увлекательными, особенно, если у вас есть дети. Для эффективной борьбы с лишним весом уделяйте скакалке 20 минут в день. Вы сбросите более ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "250 калорий.\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Сохраняйте информацию себе в заметки. Пусть ваш путь к стройности будет веселым и полным удовольствия!\n\nУспехов вам!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 1:
//                model.image = #imageLiteral(resourceName: "7")
//                model.name = "Что кушать до и после тренировки?"
//                model.title = "Я худею, значит, должна меньше кушать? Однозначно нет. Еда – ваш главный помощник на пути к стройности. Для этого нужно лишь соблюдать определенный режим питания."
//                model.alphaViewColor = #colorLiteral(red: 0.1773408651, green: 0.8453863263, blue: 0.8188639283, alpha: 1)
//                model.category = .nutrition
//                model.premium = false
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                mutableAttrString.append(NSAttributedString(string: "На тренировках мы тратим энергию. Но для того чтобы потратить, нужно ее откуда-то получить. Основной источник энергии – пища, богатая углеводами. Ценность долгих углеводов в том, что в процессе тренировок они активно расщепляются, а это приводит к быстрой потере веса.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Что кушать перед пробежкой или походом в фитнес–клуб, если вы хотите похудеть?\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•  Орехи (грецкий, фундук)\n•  Ягоды (малина, клубника, черника)\n•  Фруктовые смузи, фрукты (бананы, яблоки)\n•  Морковь\n•  Творог с низким содержанием калорий\n•  Яйцо\n•  Цельнозерновые каши (гречка, овсянка)\n•  Индейка/курица/рыба.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//              mutableAttrString.append(NSAttributedString(string: "Хотим похудеть – забываем про вредные углеводы: газировки, мучные изделия, виноград, мед. Съели их перед тренировкой – получили отложения в виде подкожного жира.\n\nЕсли вы хотите подтянуть тело и нарастить мышцы, добавьте порцию белка перед тренировкой. Для этого подойдут курица с рисом, рыба с овощами или яйца с гречкой.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//              mutableAttrString.append(NSAttributedString(string: "Что кушать после тренировки, если вы хотите сбросить вес?\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//            mutableAttrString.append(NSAttributedString(string: "Кушайте сразу после тренировки независимо от ваших целей. Сразу после занятия выпейте воды, съешьте банан или пару сухофруктов. Клюквенный морс или виноградный сок – идеальные варианты. В них содержатся быстрые углеводы, которые мгновенно повышают чувствительность к инсулину в мышцах и понижают – в жировых клетках.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//             mutableAttrString.append(NSAttributedString(string: "Если вы работаете на уменьшение объемов, то привычный прием пищи начните через 1–1,5 часа. До этого ваш организм работает на сжигание жиров. Придя домой, отдайте предпочтение белку (яйца, рыба, морепродукты) и клетчатке (овощи). А белком можно заправляться еще в раздевалке. Например, самодельными или порошковыми коктейлями из протеина.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "После физической нагрузки забудьте о напитках, содержащих кофеин. Они замедляют выработку инсулина.\n\nЭти простые правила питания помогут увидеть результаты от тренировок гораздо быстрее, чем вы ожидаете!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 2:
//                model.image = #imageLiteral(resourceName: "8")
//                model.name = "План тренировок на 21 день от инструктора «World Class»"
//                model.alphaViewColor = #colorLiteral(red: 0.8602494597, green: 0.3586550653, blue: 0.4286826551, alpha: 1)
//                model.category = .training
//                model.premium = true
//                
//                let mutableAttr = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                mutableAttr.append(NSAttributedString(string: "Если дел слишком много, а времени на спорт совсем не остается – мы подскажем, что вам делать.\n\nЗнакомьтесь с универсальным планом тренировок, рассчитанным на 21 день. Программа разработана двукратными чемпионами мира по фитнесу и инструкторами тренажерного зала «World Class».\n\nЦель программы – активная круговая тренировка на проработку всех мышц. Считайте, что ваше тело будет сжигать калории ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttr.append(NSAttributedString(string: "каждый день.", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                model.attributedTitle = mutableAttr
//                
//                let mutableAttrString = NSMutableAttributedString()
//                mutableAttrString.append(NSAttributedString(string: "Неделя 1\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Понедельник:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка + сила\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Вторник:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардио\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Среда:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " сила\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Четверг:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардио\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Пятница:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка + сила\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Суббота/воскресенье:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " выходной.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "В качестве кардионагрузки выбирайте бег, прогулку на велосипедах, бассейн, игру в большой теннис и т.д. Не забываем про ходьбу по лестнице или пешие прогулки.\n\nCиловая тренировка состоит из двух частей. Каждую часть проходим по 3 раза. Не забываем в перерывах отдыхать и пить воду.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Часть 1:\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 20), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•  Глубокие выпады назад по 20 повторов на каждую ногу\n•  Становая тяга с утяжелением (20 повторов)\n•  Тяга в наклоне с гантелями по 4 кг (20 повторов)\n•  Отжимания. Выполняем по 20 повторов. Для облегчения упражнения можно встать на колени\n•  Обратные скручивания. Тренировка направлена на мышцы пресса. Выполняем по 20-30 скручиваний. После нее пресс будет гореть.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Часть 2:\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 20), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•  Отведение рук в стороны с утяжелителем (20 повторов)\n•  Разгибание рук в наклоне с утяжелителем (20 повторов)\n•  Отведение бедра в положении лежа (30 повторов). Держите спину ровно и разводите бедра не больше, чем на 45 градусов. Возвращайтесь в исходную позицию плавно\n•  Приведение бедра лежа (30 повторов)\n•  Скручивания на верхний пресс.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Неделя 2\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Понедельник:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка + сила\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Вторник:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Среда:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " сила+ кардионагрузка\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Четверг:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Пятница:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " сила + кардионагрузка\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Суббота/воскресенье:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " выходной.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Вы заметили, что кардионагрузок стало больше? Тело привыкает, поэтому повышаем интенсивность. Не усердствуйте! Следите за своим состоянием.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Неделя 3\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Понедельник/среда/пятница:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка + сила\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Вторник/четверг:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " кардионагрузка\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Суббота/воскресенье:", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: " выходной.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "В дни, когда кардио стоит с силой, еще немного увеличиваем нагрузку (бегаем в горку в течение часа).\nВ кардиодни вносим разнообразие интервальными упражнениями:\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•  Ходьба пешком: 2 минуты\n•  Легкий бег: 4 минуты\n•  Быстрый бег: 2 минуты\n•  Переход на легкий бег: 2 минуты.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Выполняем по 5 подходов, а затем добивку на пресс.\n\nТренируйтесь с удовольствием!\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 3:
//                model.image = #imageLiteral(resourceName: "9")
//                model.name = "Рацион питания на неделю 1500 ккал/день"
//                model.title = "Думаете, диетическое питание — это сплошные «грудка и гречка»? Готовы с этим поспорить. Разнообразие продуктов этого рациона доставит вам гастрономический восторг. И никакого переедания!"
//                model.alphaViewColor = #colorLiteral(red: 0.8359896541, green: 0.6353785992, blue: 0, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "День 1\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "овсянка с кусочками банана и корицей + куриное яйцо (55 г). Овсянку варим на воде с добавлением 1,5% молока (60 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "банан (100 г), чернослив (30 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "гречка (100 г), куриная грудка (100 г), салат из белокочанной капусты и огурцов (100 г), зерновой хлеб (20 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "яблоко (20 г), сухофрукты (30 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "минтай (200 г), салат из свежих огурцов, помидоров и белокочанной капусты (100 г). Заправить оливковым маслом (200 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Вечерний перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "кефир (350 г).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                
//                mutableAttrString.append(NSAttributedString(string: "День 2\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "омлет + кофе или чай без сахара. Яйцо куриное – 2 шт. (110 г), молоко (30 г), сыр (20 г), брокколи (70 г). Зерновой хлеб (20 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "персики (300 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "рис (50 г), минтай (200 г), салат из морской капусты (150 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "бутерброд. Сыр (40 г), зерновой хлеб (40 г), помидор (50 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "запеченная куриная грудка (100 г) в сметане 15% с чесноком, сыром и помидорами\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Вечерний перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "кефир (350 г).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "День 3\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "бутерброд. Сыр (40 г), зерновой хлеб (40 г), помидор (50 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "нежирный творог (100 г), мед (20 г), яблоко (100 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "картофель (300 г), куриная грудка (100 г), брокколи (70 г), зерновой хлеб (20 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "банан (100 г), апельсин (150 г).\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "запеченная грудка индейки (300 г), салат из томатов черри, сладкого перца, кукурузы, сыра и салата Айсберг\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "кефир 1,5% (350 г).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "День 4\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "геркулесовая каша (50 г), изюм (10 г), мед (10 г), бутерброд с сыром (30 г) и хлебом\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "яблоко и банан (200 г), апельсин (150 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "спагетти (50 г), куриная грудка (100 г), салат из томатов черри, оливкового масла и сыра (140 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "мякоть арбуза (400 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "грудка куриная (100 г) Обвалять в смеси из яйца, воды и зелени. Запекать в духовом шкафу 35 минут. Итого: 310 г\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "кефир 1,5% (350 г).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//
//                mutableAttrString.append(NSAttributedString(string: "День 5\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2 куриных яйца всмятку (110 г), геркулесовая каша (30 г) на воде с добавлением меда, яблока и корицы. Итого: 112 г\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "свежая морковь (300 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "рис (50 г) с отварной куриной грудкой (100 г) Промываем рис, обжариваем грудку, лук, морковь на оливковом масле Добавляем отваренный рис. Тушим 20-25 минут. Подаем с малосольными огурцами (200 г). Итого без учета огурцов: 410 г\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "мякоть манго (200 г).\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "консервы из тунца в собственном соку (200 г), томаты черри (100 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "кефир 1,5% (350 г).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "День 6\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "гречка (50 г), зелень (50 г), сыр (20 г), яйцо куриное (1 шт.). Отвариваем гречку и яйцо. Остальные ингредиенты мелко режем, добавляем соль и смешиваем с гречкой\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "грейпфрут и апельсин (200 г), банан (100 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "гречка (50 г), стручковая фасоль (200 г), сыр (30 г), перец чили (20 г), подсолнечное масло (10 г). Овощи обжариваем на масле, варим гречку. Смешиваем все и посыпаем сыром\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "грецкие орехи (40 г).\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "отварная свекла (150 г) и куриная грудка (100 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "кефир 1,5% (350 г).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "День 7\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 24), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Завтрак: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "клубника (100 г), йогурт натуральный (300 г), мед (10 г). Все смешиваем в один вкусный коктейль\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Перекус: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "груша (200 г), мед (20 г), грецкие орехи (30 г). Делаем вкусный десерт. Вынимаем из груши мякоть, поливаем медом и кладем грецкий орех. Запекаем в духовке 10 минут\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Обед: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "спагетти (100 г), тунец в собственном соку (100 г), зеленый горошек (100 г) и оливковое масло (10 г)\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Полдник: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "йогурт без добавок (150 г) и яблоко (100 г).\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•   Ужин: ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "тунец в собственном соку (200 г), горошек (100 г), томаты черри (100 г). Все смешиваем и сбрызгиваем лимонным соком.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Питайтесь вкусно и полезно!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 4:
//                model.image = #imageLiteral(resourceName: "10")
//                model.name = "Как идти до конца, когда решили перейти на ЗОЖ?"
//                model.title = "Решение принято. Вы выбрали себя и свое здоровье. Поздравляем, первый этап пройден! Но достаточно ли в вас запала для работы? Как не свернуть с пути? Познакомьтесь еще с несколькими причинами дойти до конца."
//                model.alphaViewColor = #colorLiteral(red: 0.3521829247, green: 0.4806922674, blue: 0.7428974509, alpha: 1)
//                model.category = .training
//                model.premium = false
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1. Удовлетворяем высшие потребности\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Слышали о Маслоу и его знаменитой пирамиде потребностей? Первый уровень пирамиды – физиологические нужды. Не удовлетворяя их, мы не сможем комфортно жить. Да и жить вообще. Верхняя точка пирамиды – потребность в духовном развитии и совершенствовании себя. Чем выше уровень, тем больше удовольствия от жизни вы получаете.\n\nЗдоровый образ жизни – это и укрепление духа, и повышение самооценки, и саморазвитие. А значит, удовольствие вы будете получать на самых разных уровнях:)\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. Перспективы на будущее\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Съеденный гамбургер не принесет вам вреда сейчас. Напротив, он принесет моментальное удовольствие. То же скажем и про выкуренную сигарету, выпитую бутылку пива и пропущенную тренировку. Но вы должны помнить о последствиях регулярных послаблений. Из-за сигарет вы вряд ли пробежите 2 км без одышки. А пропущенная тренировка повлечет за собой и другие прогулы.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Вносим разнообразие\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Спорт – это однообразно и скучно? Как бы не так. Занятия спортом дают массу эмоций и поднимают настроение.\nЕсли вы почти раздумали идти на тренировку из-за лени, то скажем вот что. После спорта вы почувствуете себя гораздо бодрее, чем проведя вечер на диване. К тому же, будете гордиться собой.\n\nПоездка с друзьями на велосипедах за город, пробежка по набережной или марафон бегунов в конце концов могут стать лучшими приключениями в вашей жизни.\n\nА еще вы заведете новых друзей и хобби.\nПрекрасные перспективы, согласны? Сохраняйте наши советы и вешайте их на видное место.", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 5:
//                model.image = #imageLiteral(resourceName: "11")
//                model.name = "5 способов перейти на правильное питание без стресса"
//                model.title = "С чего начать переход на правильное питание? Отказаться от сладостей и фастфуда? Оказывается, можно этого не делать, и все равно быть сторонником ЗОЖ. Как же это осуществить?"
//                model.alphaViewColor = #colorLiteral(red: 0.8172749877, green: 0.08746068925, blue: 0, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1. Составляем список перед походом в магазин\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Покупайте продукты ярких цветов: красных, зеленых, желтых. Доказано, что почти все они полезны. Включаем в список куриную грудку, яйца, зелень, творог и цельнозерновой хлеб. Если вы перешли на «светлую» сторону, рекомендуем найти в вашем городе магазин органических продуктов и периодически туда заглядывать. А еще можно заказывать полезную еду на дом.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. Делаем заказ в ресторане первым\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Фишка в том, что так вы защитите себя от стадного чувства. Соблазн попробовать вкусный десерт «как у соседа» очень высок. Остановились на салате – значит, оставайтесь верными своему решению.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Отказываемся от соусов\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Состав соусов далек от идеала. Заменяем соусы растительными маслами. Они придадут блюду не менее изысканный вкус и раскроют его по-новому. В ресторанах просите приносить соус отдельно от блюда. \n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4. Меняем соль на специи\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Соль приносит больше вреда, чем пользы. Однако не отказывайтесь сразу полностью от ее потребления, ведь мы привыкли чувствовать соленый вкус в блюдах. Попробуйте заменять ее ароматными специями и травами. Начните с маленьких пропорций и постепенно переходите к большим.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5. Наслаждаемся едой\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Во время приема пищи уберите все планшеты и смартфоны. В идеале – выключите телевизор. Когда мы отвлекаемся, то едим механически и в большем количестве. Смакуйте каждый кусочек, наслаждайтесь им. Научитесь получать от еды удовольствие.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Правильное питание – это не катастрофа, поэтому не забывайте себя баловать. Не отказывайте себе в любимом лакомстве хотя бы раз в неделю.\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 6:
//                model.image = #imageLiteral(resourceName: "12")
//                model.name = "Заменяем шоколад: 5 продуктов, на которые можно его поменять"
//                model.title = "Я хочу скинуть вес, но как отказаться от шоколада? Шоколадную зависимость сложно побороть. Но если знать, чем его заменить, жизнь становится приятнее. Как правило, мы любим шоколад из-за содержащейся в нем глюкозы. Она поступает в кровь и мгновенно вырабатывается гормон счастья. Но можем ли мы получить тот же эффект от других продуктов? Однозначно да!"
//                model.alphaViewColor = #colorLiteral(red: 0.9663636088, green: 0.3577157557, blue: 0, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1.  Киви. ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Благодаря высокому содержанию витамина С и фруктовых кислот, он бодрит не меньше кусочка шоколада.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2.  Тыква. ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Витамин В и бета–каротин, которыми богата даже 1 тыквенная семечка, разбудит ваш организм ото сна. Варите тыквенную кашу, запекайте, грызите тыквенные семечки – это очень вкусно!\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3.  Помидоры черри. ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "По сладости они не уступают фруктам и шоколаду. В них содержится много антиоксидантов и органических кислот.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4.  Морковь ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "В ней много бета–каротина. В организме он преобразуется в витамин А и помогает бороться со стрессом.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5.  Финики ", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "В них содержится клетчатка, железо и калий. А еще в финиках много фруктозы, которая поднимает уровень сахара в крови быстрее глюкозы.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "А еще вы можете заменить шоколад рисовым пудингом. Этот десерт низкокалориен, поэтому подойдет тем, кто следит за своим питанием. На завтрак готовим с добавлением орехов, фруктов и изюма.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Но если вам все же очень хочется скушать 1 или 2 дольки, не отказывайте себе. Покупайте только настоящий черный шоколад. А еще можете устраивать чит-милы и кушать 1 раз в неделю несколько кусочков. \n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 7:
//                model.image = #imageLiteral(resourceName: "13")
//                model.name = "Как начать тренировку, если нет настроения?"
//                model.title = "Спортсмены гордятся своей силой воли и идут на тренировку, даже если валятся с ног от усталости. Но эта выдержка есть не у всех. Иногда кажется, что спорт отнимает у нас много сил. На самом деле это не так. Представьте, что у нашего организма есть внутренний аккумулятор. И тренировки его как раз подзаряжают.\nПознакомьтесь с нескольким лайфхаками того, как замотивировать себя на тренировку, если совсем не хочется."
//                model.alphaViewColor = #colorLiteral(red: 0.1777733266, green: 0.4609492421, blue: 0.3831967115, alpha: 1)
//                model.category = .training
//                model.premium = false
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1.  Тренируемся дома\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Если за окном кружит вьюга или льет как из ведра, никому не захочется покидать дом ради тренировки. Почему бы не устроить ее дома?\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2.  Готовим сумку с вечера\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Так вы увеличите шанс попасть на тренировку. А если и это не помогло, то сумка будет вас безмолвно укорять.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3.  Командные тренировки\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Некоторым скучно заниматься в одиночестве. Заведите себе товарищей, которые приходят в одно и то же время с вами. Так вам будет веселей, и будет кому подержать штангу.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4.  Меняем план тренировки\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Когда настроение на нуле, то вы можете отступить от плана тренировки и побаловать себя. Например, выполнить любимые упражнения вместо обязательных. Импровизация – это прекрасно!\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5.  Фокус на тренировке\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Сосредотачиваемся на дыхании, движениях, ощущениях в мышцах. Мысли о плохом настроении уйдут на задний план.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "6.  Записываемся на марафон\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Желательно в другом городе или стране. А еще лучше заранее оплатить регистрационный взнос и билет. Тогда вы точно не свернете с пути.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Мотивируйте себя правильно!\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 8:
//                model.image = #imageLiteral(resourceName: "14")
//                model.name = "6 вредных продуктов, которые на самом деле полезны"
//                model.title = "Диетологи запрещают многие продукты. Нас страшат картофелем и макаронами, которые, уверены, многие из нас привыкли кушать с детства. Неужели все, что мы любим, настолько опасно для нашего организма? Давайте разбираться вместе."
//                model.alphaViewColor = #colorLiteral(red: 0.9453713298, green: 0.8582155704, blue: 0.5912497044, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1.  Попкорн\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Оказывается, попкорн – одно из древнейших блюд, дошедших к нам почти в неизменном виде. Его история начинается около 80 тысяч лет назад.\n\nПольза попкорна вот в чем: он богат клетчаткой и обладает антиоксидантными свойствами за счет полифенола. Быстро дает организму чувство сытости.\n\nВреден лишь тот попкорн, который готовили в масле, с добавлением соли или карамелизированного сахара.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2.  Майонез\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Речь идет о домашнем майонезе. Этот прекрасный соус подарит нашему организму витамины A, D, E, C. А еще комплекс витаминов B, который помогает в борьбе с инфекциями. Оливковое масло и яйца содержат полезные аминокислоты, ускоряющие обменные процессы в организме.\n\nК сожалению, такого нельзя сказать о покупном продукте.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3.  Сливочное масло\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "В нем содержатся витамины D, C, B, E, A, а также кальций и аминокислоты. Так что смело намазывайте масла на кусочек утреннего хлеба. Только не стоит его переедать, иначе он отложится в виде холестерина.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4.  Картофель\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "В печеном картофеле содержится клетчатка, а также витамины B6 и C. Один-два раза в неделю запекайте картофель в духовке, и вы получите эти вещества в лучшем виде. А вот жареный картофель или пюре с маслом и сметаной – не лучший выбор для худеющих.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5.  Паста\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Что самое главное при выборе пасты? Сорт пшеницы, из которой она сделана. В пшенице содержатся сложные углеводы, которые дают долгое чувство насыщения. А еще клетчатка, которая выводит из организма токсины.\n\nСамое вредное в пасте – это соус. В нем как раз содержится все, против чего выступают диетологи. Идеально подойдут паста с морепродуктами, белым вином и оливковым маслом, а также паста с соусом болоньезе.\n\nГотовьте любимые продукты правильно и лакомитесь ими на здоровье!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 9:
//                model.image = #imageLiteral(resourceName: "15")
//                model.name = "5 причин, из-за которых вес не уходит"
//                model.title = "Вы злитесь на себя, на тех, кто придумал неработающие диеты и бесполезный спорт. Как так? Кушаете по таймеру, считаете КБЖУ, порции меньше, чем у котят, регулярные изматывающие тренировки – а вес уходит буквально по капле. Или не уходит вообще."
//                model.alphaViewColor = #colorLiteral(red: 0.9343314767, green: 0.6396654248, blue: 0.4835786819, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "Есть 5 основных причин, почему весы не спешат радовать вас заветными цифрами:\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "1. Гормональные нарушения\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Это первое, что нужно выяснить! Гормоны – коварная штука. Вы можете кушать как всегда, даже ограничивать себя, и оставаться заложником гормонального фона организма.\nОбязательно проверьте функцию щитовидной железы у эндокринолога. Перед визитом к врачу сдайте минимум анализов: Т3, Т4, ТТГ.\nОсобенно стоит поторопиться, если вы:\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "•  быстро устаёте,\n•  часто бываете в подавленном настроении,\n•  испытываете сердцебиение или вялость,\n•  у вас мерзнут руки и ступни.\n\nГрамотная гормонотерапия поможет вам в борьбе с лишними килограммами.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. «Шпионы» в рационе\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Вы вроде избавились от всех вредностей. Обеспечили себе запас исключительно полезных перекусов и снеков. Но результата нет. Подумайте: может, в рацион пробрались «скрытые враги»?\nСухофрукты к чаю, сыр и орехи из дружеского стана переметнутся во вражеский, если ими злоупотреблять. Все важно в меру!\nГорсть кешью в прикуску с курагой – это калорийная бомба замедленного действия. Не рискуйте. Если испытываете явное чувство голода, лучше съесть нормальную порцию, чем закидываться орешками. Самое время разоблачить продуктовых шпионов!\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Недостаток сна\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Да, мы в курсе, как хочется расслабиться и посмотреть сериальчик до полуночи.\nИли, уложив детей, поработать до рассвета, как герой. И так каждый день.\nНо для восстановления сил нам нужно не менее 7–8 часов сна в сутки. Когда у нас недосып, то организм восполняет нехватку энергии возрастающим аппетитом.\nА если энергии регулярно не хватает? Тогда организм «запасается» жиром впрок – мало ли, сколько энергии вам понадобится в ближайшее время? А можно было просто поспать:)\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4. Поздний прием пищи\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Чем раньше вы поужинаете, тем лучше. До сна должно пройти не менее двух часов. Если вы соблюдаете строгую диету, считаете КБЖУ, но при этом едите одной ногой в кровати – результат будете ждать очень долго.\n\nУсловное правило подсчета калорий в разное время суток гласит: «всё, что съедено поздно вечером, удваивает свою калорийность». Поэтому, даже если вы съели совсем немного, организм воспримет это как «пир горой».\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5. Частое чувство голода\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Наш организм умнее, чем нам кажется. Он всегда заботится о вас, прогнозируя будущее по состоянию сейчас. Если вы часто голодны, не чувствуете насыщения – тем больше переживает ваше тело, запасая впрок каждую молекулу жира.\n\nПостоянное чувство голода – прямой сигнал включить «аварийный режим» и экономить жировые отложения. А вдруг вы совсем перестанете есть? Не принуждайте организм так страховаться. Правильное питание – это грамотный полноценный рацион, а не голодание на гречке и воде.\n\nПостарайтесь исключить эти причины, и худеть станет не только проще и комфортнее, но и быстрее!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 10:
//                model.image = #imageLiteral(resourceName: "0-2")
//                model.name = "6 суперпродуктов, ценных для организма"
//                model.title = "Знаете, что по набору продуктов в вашей тележке можно многое сказать о вашем здоровье? И если там много «вкусняшек» и почти нет «полезностей» – пора что–то менять. Предлагаем список из 6 суперполезных продуктов, которые сразу сделают ваш рацион более здоровым."
//                model.alphaViewColor = #colorLiteral(red: 0.9665471911, green: 0.1559360325, blue: 0.1003648117, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1. Семена чиа\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Просто удивительно, сколько пользы умещается в каждом крошечном семечке. Они сильнейший антиоксидант, богаты минералами и Омега–3. Да-да, оказывается, они есть не только в рыбе.\nКаждая столовая ложка семян – это почти половина суточной нормы клетчатки для женщин старше 50 лет. Да и по содержанию белка чиа обгоняют зерновые культуры в 1,5–2 раза.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. Киноа и бурый рис\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Эти злаки – просто находка для тех, кто не переносит глютен. Они снижают уровень сахара в крови, закрывают потребность в белке и прекрасно заменят картофель, белый рис и макароны.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Гималайская соль\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Наверняка не ожидали увидеть соль в списке? И в то же время она наполняет организм 80–ю ценными биологическими веществами. Так что смело заменяйте обычную соль на чистую и насыщенную минералами гималайскую.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4. Замороженные ягоды\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Прекрасный ингредиент для десертов и смузи, который всегда под рукой. Клубника, ежевика, черника, малина и другие ягоды защищают от окислительного стресса и предотвращают болезни.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5. Кокосовое и оливковое масла\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Кокосовое масло ускоряет метаболизм и остаётся безопасным для организма даже при жарке. Старое доброе оливковое не теряет своей актуальности: оно содержит полезные жиры, витамин Е и поддерживает иммунитет.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "6. Ореховое масло и молоко\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Ореховое молоко – отличная замена коровьему, особенно для тех, кто не переносит лактозу. Вообще любые орехи и продукты из них битком набиты Омега–6 (и такое бывает), витаминами и минералами. Они сохраняют сердце здоровым.\n\nДержите этот список под рукой, чтобы ваше питание было полноценным и максимально полезным!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 11:
//                model.image = #imageLiteral(resourceName: "2")
//                model.name = "Как провести детокс в домашних условиях"
//                model.title = "Детокс помогает организму очиститься от вредных веществ, избавиться от аллергий и почувствовать себя лучше. Мы подготовили для вас 10 правил детокса, которым следуют профессионалы в специализированных клиниках."
//                model.alphaViewColor = #colorLiteral(red: 0.8156437278, green: 0.8025475144, blue: 0, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "Программа рассчитана на 10 дней.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "1. Пейте от 2-х до 3-х литров воды в день\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Пить следует равномерно в течение дня (каждые 1–2 часа, а не 1,5 литра утром и 1,5 литра вечером).\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. Откажитесь от алкоголя и кофеина\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "А также замените привычный чай на травяной.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Делайте свежевыжатые соки\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Например, сок из яблока, свёклы и моркови улучшает цвет лица и очищает печень. Пейте его сразу после приготовления.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4. Добавьте в меню супы-пюре\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Вместе с соками у вас должно получиться 2 жидких приёма пищи. Тогда энергия, которая тратилась на переваривание, пойдёт на активную борьбу с токсинами.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5. Исключите продукты глубокой промышленной переработки и сахар\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Выбирая цельные продукты, следите за их качеством. К примеру, океаническую рыбу замените речной.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "6. Увеличьте физическую нагрузку\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Здесь хорошо помогают упражнения на батуте и стойки на голове, если у вас к ним нет противопоказаний.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "7. Потейте\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Ходите в сауну, хаммам или русскую баню.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "8. Регулярно делайте массаж самостоятельно и у специалиста\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Самомассаж делайте сухой щёткой по направлению от конечностей к сердцу.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "9. Digital-детокс\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Проводите меньше времени за компьютером, перед телевизором и гаджетами.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "10. Проверьте качество вашей косметики и бытовой хими\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Вполне вероятно, что после этого у вас исчезнет аллергия на кошек, собак или какой-нибудь продукт питания.\n\nСледуйте этим правилам, и за 10 дней домашнего детокса ваше самочувствие заметно улучшится!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 12:
//                model.image = #imageLiteral(resourceName: "3")
//                model.name = "Травы, поднимающие настроение"
//                model.title = "Разумеется, мы говорим только о травах, которые употреблять вполне законно. Когда на душе скребутся кошки, в голове неразбериха, а память частенько выдаёт сбой — нужны особые средства. Мы составили список трав-антидепрессантов для устранения этих симптомов. Но помните о том, что консультация со специалистом всё же понадобится."
//                model.alphaViewColor = #colorLiteral(red: 0.262373209, green: 0.3246269822, blue: 0, alpha: 1)
//                model.category = .nutrition
//                model.premium = true
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1. Лимонный бальзам\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Безопасное растение, которым лечат бессоницы, нервозное состояние и депрессии. Оказывает сильное успокаивающее действие даже в небольших дозах.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2. Женьшень\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Растение, которое поможет перед экзаменом: оно улучшает концентрацию и память, убирает тревогу и повышает умственную выносливость.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3. Родиола розовая или золотой корень\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Эта трава тоже усиливает мыслительные способности, положительно влияет на память и устраняет симптомы депрессии.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4. Страстоцвет\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Прекрасно справляется с тревожностью в дневное время и помогает глубоко заснуть ночью.\nВсе эти травы можно заваривать как чай или принимать в настойках. Но есть и другой вариант — ароматерапия. Эфирные масла тоже улучшают эмоциональное состояние.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5. Розмарин\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Его даже называют «травой памяти». Этот аромат поможет сконцентрироваться, прояснит сознание и устранит усталость.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "6. Мята перечная\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Охлаждает и освежает, мгновенно повышая настроение.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "7. Базилик\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Считается эффективным тонизирующим средством. Очищает голову и прекрасно снимает умственную усталость.\n\nУкреплять память и улучшать настроение с помощью трав явно лучше, чем с помощью таблеток. Только имейте в виду, что даже в этом нужно соблюдать меру.\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 13:
//                model.image = #imageLiteral(resourceName: "4")
//                model.name = "Зачем считать КБЖУ?"
//                model.title = "Подсчёт КБЖУ — это основа диетологии. Вы набираете вес, когда съедаете калорий сверх своей нормы и худеете, если съедаете меньше. Поэтому самый простой способ похудеть начинается с пищевого дневника."
//                model.alphaViewColor = #colorLiteral(red: 0.5990627408, green: 0.755192697, blue: 0.2078273296, alpha: 1)
//                model.category = .nutrition
//                model.premium = false
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "«Можно с ума сойти, если постоянно считать калории» — можете подумать вы. Но мы как раз и создали приложение, чтобы облегчить вам эту головную боль. Перед вами рецепты на любой вкус с уже рассчитанной пищевой ценностью. Вам остаётся только внести их в свой дневник и не превышать норму. Относитесь к этому как к игре.\n\nЧто вам дадут подсчёт КБЖУ и пищевой дневник?\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "•  Вы увидите, какие приёмы пищи вас насыщают, а какие только усиливают голод. Сможете скорректировать меню и избежать срывов.\n•  Вы перестанете верить в сказки про запретные продукты и отказ от еды после 18 часов. Сможете есть любимые продукты в умеренном количестве и не винить себя.\n•  Перед вами будут объективные факты: ваш рацион, точная пищевая ценность и другие данные. Так вы учитесь управлять своим питанием и худеете без вреда для здоровья.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Следите за своим рационом и будьте счастливы!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 14:
//                model.image = #imageLiteral(resourceName: "1")
//                model.name = "Как составить план питания?"
//                model.title = "У плана питания есть ряд преимуществ и недостатков, но плюсы определённо перевешивают. Смотрите сами: вы экономите время и деньги, меньше стрессуете, у вас есть стабильность в рационе и гарантия результата. Приятно? Конечно. Так давайте составим план питания, не откладывая!"
//                model.alphaViewColor = #colorLiteral(red: 0.3209783137, green: 0.4189351201, blue: 0.1764899492, alpha: 1)
//                model.category = .nutrition
//                model.premium = false
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1. Рассчитайте вашу норму калорий и количество приёмов пищи\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Учтите рост, вес, возраст, физическую нагрузку. Будьте честны с собой.\n\nЧто касается приёмов пищи, то оптимальное количество — от 3 до 5 раз в день вне зависимости от того, набираете вы вес или худеете.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2.  Разбейте пищу на БЖУ\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Примерно 50% рациона составляйте из медленных углеводов (макароны твёрдых сортов, бурый рис). А вот потребность в белке может варьироваться от 1 г на 1 кг веса при отсутствии спортивной нагрузки до 1,8 г на 1 кг веса при силовых тренировках. Самое большое количество белка нужно тем, кто «сушится» (снижает процент жира) — до 2,5 г на 1 кг в день.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "3.  Составьте план по принципу «1/5 рациона любимой еды и 4/5 — полезной»\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Это значит 80% продуктов в рационе — это мясо, рыба, овощи, фрукты, орехи, молочные продукты. А остальные 20% — совершенно любые вредности, которые вы обожаете. Именно благодаря этому хитрому подходу риск сорваться стремится к нулю.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "4.  Чит-мил или день «не по плану»\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Это, например, пицца в честь дня рождения. Помните, что 1 такой день не срывает все ваши планы. Просто продолжайте двигаться дальше.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "5.  Гибкий план питания\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "На этом этапе вы уже знаете, чем и как питаться, чтобы поддерживать вес в нужной форме. Вы отходите от жёстких рамок к продуманному и сбалансированному питанию.\n\nСоставляйте план так, чтобы ваше меню было не только полезным и диетическим, но и вкусным и разнообразным. Худейте в своё удовольствие!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            case 15:
//                model.image = #imageLiteral(resourceName: "5")
//                model.name = "Почему вы никогда не похудеете?"
//                model.title = "Более стройная фигура — это не только здоровье и эстетика. Это ещё и высокий уровень жизни. Стройное тело, новый костюм, бодрость и энергия на достижение целей... Когда вы добиваетесь цели в похудении, вы становитесь гораздо успешнее в личной жизни, бизнесе, вместе с вами растёт ваше окружение. И мы не случайно начали с того, что всё в жизни у нас связано. Читайте первую причину, и сами всё поймёте."
//                model.alphaViewColor = #colorLiteral(red: 0.7032240033, green: 0.2262503505, blue: 0.2040180266, alpha: 1)
//                model.category = .nutrition
//                model.premium = false
//                
//                let mutableAttrString = NSMutableAttributedString()
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 5
//                paragraphStyle.alignment = .left
//                
//                mutableAttrString.append(NSAttributedString(string: "1.  Любые исключения и послабления в вашей жизни развивают привычку сдаваться\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Согласились на меньшую зарплату, прогнулись под чужие условия, «разрешили» себе не выполнить обязательства. Казалось бы, причём тут похудение? На самом деле каждый такой выбор учит вас пасовать, причём в любом вашем начинании. И диета не становиться исключением.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Что делать?\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Тренируйте цепочку привычек. Выберите 1 привычку на месяц и повесьте чистый лист на видное место. Каждый день рисуйте на нём красивую галочку, если сделали что-то для своего похудения. Допустим, потренировались, отказались от привычной «вкусняшки» или выпили нужное количество воды. Задача — не оставить ни одного дня без отметки. \n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "2.  Вторая причина — отсутствие стратегии\n\n", attributes: [.font: UIFont.sfProTextHeavy(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                mutableAttrString.append(NSAttributedString(string: "Люди, которые хотят похудеть, просто не готовы к трудностям. Они не продумали план действий на случай, если что-то пойдёт «не так». Поясняем и сразу предлагаем варианты решений.\n\n", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.append(NSAttributedString(string: "•  Вспомните всё, что помешало вам похудеть в прошлый раз. Критика близких, нервное поедание сладостей на работе, ненависть к тренировкам в зале... Придумайте, что вы будете делать иначе в этот раз, чтобы теперь дойти до конца. Например, будете держать на работе полезные перекусы и выберете танцы вместо штанги.\n•  Покупайте вещи меньшего размера. Найдите фотографии, где вы в своей лучшей форме. Это вдохновляет лучше, чем фото самых роскошных моделей в бикини.\n•  Планируйте действия и не оставляйте себе выбора. Это означает, что вы не можете пропустить тренировку, потому что иначе сгорит предоплата. А все приёмы пищи и правильные перекусы у вас уже заранее приготовлены и разложены по контейнерам. У вас чёткий распорядок дня и вы знаете, какое следующее действие приведёт вас к фигуре вашей мечты.\n\nБудьте терпеливы и регулярны — тогда у вас всё получится!", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
//                
//                mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
//                model.text = mutableAttrString
//            default:
//                break
//            }
//            if model.category == .nutrition {
//                nutritionModels.append(model)
//            } else {
//                trainingModels.append(model)
//            }
//        }
        return [nutritionModels.shuffled(), trainingModels.shuffled()]
    }
}
