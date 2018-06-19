&НаКлиенте
Перем SQLiteObject; 

&НаСервере
Функция ПолучитьИмяФайлаОбработкиСервер()
	Об = РеквизитФормыВЗначение("Объект");
	Возврат Об.ИспользуемоеИмяФайла;
КонецФункции

&НаСервере
Функция ПолучитьИмяКаталогаОбработкиСервер()
	Об = РеквизитФормыВЗначение("Объект");
	ИмяФайла =  Об.ИспользуемоеИмяФайла;
	МассивПолей = РазложитьСтрокуВМассивПодстрок(ИмяФайла, "\");
	Рез = "";
	Для сч = 0 По МассивПолей.Количество()-2 Цикл
		Рез = Рез + МассивПолей.получить(сч)+"\";
	КонецЦикла;
	Возврат Рез;
КонецФункции

&НаКлиенте
Процедура СоздатьБазу(Команда)
	
	Если НайтиФайлы(ПутьКБазе).Количество()>0 Тогда
		Вопрос = "Файл уже существует! Продолжить создание пустой базы?";
		Если Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена,,КодВозвратаДиалога.Отмена) = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	//Вопрос()
	
	//sqlite3.exe должен быть зарегистрирован в переменной path или лежать рядом с обработкой
	
	КаталогОбработки = Неопределено;
	//СоздатьБазуНаСервере(КаталогОбработки);
	КаталогОбработки = ПолучитьИмяКаталогаОбработкиСервер();
	
	//типы данных
	//https://www.sqlite.org/datatype3.html
	//_Storage Classes and Datatypes
	//Each value stored in an SQLite database (or manipulated by the database engine) has one of the following storage classes:
	//    NULL. The value is a NULL value.
	//    INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
	//    REAL. The value is a floating point value, stored as an 8-byte IEEE floating point number.
	//    TEXT. The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16LE).
	//    BLOB. The value is a blob of data, stored exactly as it was input.

	//Note that a storage class is slightly more general than a datatype. The INTEGER storage class, for example, includes 6 different integer datatypes of different lengths. This makes a difference on disk. But as soon as INTEGER values are read off of disk and into memory for processing, they are converted to the most general datatype (8-byte signed integer). And so for the most part, "storage class" is indistinguishable from "datatype" and the two terms can be used interchangeably.
	//Any column in an SQLite version 3 database, except an INTEGER PRIMARY KEY column, may be used to store a value of any storage class.
	//All values in SQL statements, whether they are literals embedded in SQL statement text or parameters bound to precompiled SQL statements have an implicit storage class. Under circumstances described below, the database engine may convert values between numeric storage classes (INTEGER and REAL) and TEXT during query execution.
	//2.1. Boolean Datatype
	//SQLite does not have a separate Boolean storage class. Instead, Boolean values are stored as integers 0 (false) and 1 (true).
	//_2.2. Date and Time Datatype
	//SQLite does not have a storage class set aside for storing dates and/or times. Instead, the built-in Date And Time Functions of SQLite are capable of storing dates and times as TEXT, REAL, or INTEGER values:
	//    TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS").
	//    REAL as Julian day numbers, the number of days since noon in Greenwich on November 24, 4714 B.C. according to the proleptic Gregorian calendar.
	//    INTEGER as Unix Time, the number of seconds since 1970-01-01 00:00:00 UTC. 
	//Applications can chose to store dates and times in any of these formats and freely convert between formats using the built-in date and time functions.	
	
	//создать файл команд для создания базы и таблиц
	ТекстКоманд = Новый ТекстовыйДокумент;
	ТекстКоманд.УстановитьТекст(
	"create table positions(
	|ticker varchar(50), 	--код инструмента
	|class text, 			--класс инструмента
	|quantity integer, 		--количество (в штуках), может быть отрицательным, если это шорт
	|amount integer, 		--себестоимость
	|bid numeric,			--цена бид
	|ask numeric,			--цена аск
	|last numeric			--цена последней сделки
	|);
	|insert into positions values(
	|'SiZ6',
	|'SPBFUT',
	|10,
	|638000,
	|63750,
	|63850,
	|63840
	|);
	|delete from positions;
	|create table deals(account text, class text, dealNumber bigint, dealDate date, ticker text, quantity int, price int, amount int, curency text, direction text);
	|insert into deals values ('99999','FORTS', 999555999555, '2016-10-15 10:00:00', 'Si-12.16', 2, 64300, 128600, 'RUR', 'buy');
	|delete from deals;
	|.exit");
	ФайлКоманд = КаталогВременныхФайлов()+"commandSqlite.txt";
	ТекстКоманд.Записать(ФайлКоманд,КодировкаТекста.ANSI);
	
	
	//Сообщить(КаталогОбработки);
	КомандаСистемы(КаталогОбработки+"sqlite3 "+ПутьКБазе+" < "+ФайлКоманд);
	
	//sqlite3 database.db < commands.txt
КонецПроцедуры

//спижжено из БСП, модуль СтроковыеФункцииКлиентСервер
&НаСервере
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",")
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр, Поз - 1));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				Если (СокрЛП(Стр) <> "") Тогда
					МассивСтрок.Добавить(Стр);
				КонецЕсли;
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз - 1));
			Стр = Сред(Стр, Поз + ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ПутьКБазе") Тогда
		ПутьКБазе = Параметры.ПутьКБазе;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	RS = SQLiteObject.Execute(ТекстЗапроса);
	
	Если RS.State=0 Тогда
		//это был запрос без возвращения рекордсета
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса.Очистить();
	
	Пока НЕ RS.EOF Цикл
		
		Стр="";
		
		Для сч = 0 По RS.Fields.count()-1 Цикл
			
			Стр=Стр+RS.Fields(сч).value+Символы.Таб;
			
		КонецЦикла;
		
		RS.MoveNext();
		
		
		РезультатЗапроса.ДобавитьСтроку(Стр);
		
	КонецЦикла;	
КонецПроцедуры

//http://infostart.ru/public/103371/
&НаКлиенте
Функция SQLiteInit() Экспорт
    SQLiteObject = Новый COMОбъект("ADODB.Connection");
    //SQLiteConnectionString = "DRIVER=SQLite3 ODBC Driver;Database=" + ФайлБД + ";";
	//SQLiteConnectionString = "DRIVER=SQLite3 ODBC Driver;Database=" + ФайлБД + ";LongNames=0;Timeout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;";
	SQLiteConnectionString = "DSN=SQLite3 Datasource;Database=" + ПутьКБазе + ";StepAPI=0;SyncPragma=NORMAL;NoTXN=;Timeout=100000;ShortNames=;LongNames=;NoCreat=;NoWCHAR=;FKSupport=;JournalMode=;OEMCP=;LoadExt=;BigInt=;JDConv=;PWD=";
    Попытка
        SQLiteObject.Open(SQLiteConnectionString);
    Исключение
        //Сообщить("Невозможно подключится к драйверу SQLite. Возможно файл [" + ФайлБД + "] открыт другим пользователем или программой!");
		Сообщить(ОписаниеОшибки());
        Возврат Ложь;
    КонецПопытки;
    Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	SQLiteInit();
КонецПроцедуры
