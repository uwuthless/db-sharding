Copyright Michael Medvedskiy, 2020

start: `sudo docker-compose -f docker-compose.yaml up --build`


План шардинга

У нас есть – 3 БД Payment, 1 БД Associations (senderId, DBId)

    1. Получить список платежей, пример – 10 платежей с 8 уникальными id отправителя = List<Payment>(10) (т.к. могут быть абсолютно одинаковые)
    2. Кластеризовать прешедшие платежи по уникальным id отправителя
        = Map<SenderId, List<Payment>>(8)
    3. По каждому SenderId определить, в какой из трёх бд должен быть каждый кластер кластер. Если в какой-то из БД есть такой ID, то выбирается эта БД, если нет – по алгоритму выбирается новая (по факту – БД для записей с “таким” SenderId)
       = Map<SenderId, DBId> (8)
        1. Итерируемся через все senderId, делаем чтение из БД Associations where senderId = id Сендера из кластера. Если непустой ответ, то из вернувшегося ответа берём DBId, Если пустой, то считаем новый DBId от id Сендера из кластера //паралелится, но малый профит, так что не стоит
    4. Все Payment из кластеров с одинаковым Id сливаются в один List (3)
    5. Каждый из Листов персистится в соответствующую БД