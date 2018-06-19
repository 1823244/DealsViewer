//работа с SQLite
//примеры взяты здесь: http://infostart.ru/public/103371/
//для этих функций нужен драйвер "SQLite ODBC Driver"
//http://www.ch-werner.de/sqliteodbc/


Перем SQLiteObject; 

//http://infostart.ru/public/103371/
Функция SQLiteInit(ФайлБД) Экспорт
    SQLiteObject = Новый COMОбъект("ADODB.Connection");
    SQLiteConnectionString = "DRIVER=SQLite3 ODBC Driver;Database=" + ФайлБД + ";";
    Попытка
        SQLiteObject.Open(SQLiteConnectionString);
    Исключение
         Сообщить("Невозможно подключится к драйверу SQLite. Возможно файл [" + ФайлБД + "] открыт другим пользователем или программой!");
        Возврат Ложь;
    КонецПопытки;
    Возврат Истина;
КонецФункции

//http://infostart.ru/public/103371/
Функция SQLiteQuery(Запрос) Экспорт
    SQLiteRS = Новый COMОбъект("ADODB.Recordset");
    Попытка
        SQLiteRS = SQLiteObject.Execute(Запрос);
    Исключение
        Сообщить("Невозможно выполнить SQL запрос " + ОписаниеОшибки(), СтатусСообщения.Важное);
        Возврат Ложь;
    КонецПопытки;
    
    Возврат SQLiteRS;
КонецФункции

//http://infostart.ru/public/103371/
Функция Example()
	
    МаркиАвтомобилей = SQLiteQuery("SELECT ID, Name FROM Auto ORDER BY ID");
    Пока НЕ МаркиАвтомобилей.EOF Цикл
        ID = МаркиАвтомобилей.Fields(0).value;
        Name = МаркиАвтомобилей.Fields(1).value;
        Сообщить("ID/Name: " + ID + "/" + Name);
        МаркиАвтомобилей.MoveNext();
	КонецЦикла;
	
КонецФункции

//конец примеров
//test