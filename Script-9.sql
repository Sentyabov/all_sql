CREATE table tst_boardcap (
	board varchar,
	CapC int(10),
	CapY int(10),
	DateBegUTC datetime,
	DateEndUTC datetime,
	TSTAMP datetime
)

alter table tst_flights rename to tst_boardcap;

drop table tst_boardcap

create table tst_flights (
	FlightDateUTC datetime,
	FlightNumber varchar,
	Pax int(10),
	Board varchar
)

drop table tst_flights 



SELECT STRFTIME('%W', FlightDateUTC) AS WeekNumber,
	SUM(Pax) AS Pax
FROM TST_Flights
GROUP BY STRFTIME('%W', FlightDateUTC)


SELECT STRFTIME('%W', FlightDateUTC) AS WeekNumber,
	ROUND(100 * SUM(CAST(Pax as float))/
SUM(b.CapC + b.CapY), 3) AS LoadFactor
FROM TST_Flights f INNER JOIN TST_BoardCap b
	ON f.Board = b.Board
GROUP BY STRFTIME('%W', FlightDateUTC);

select tf.*,
		sum(tf.pax),
		sum(tb.CapC + tb.CapY)
		from tst_flights tf 
		inner join tst_boardcap tb on tb.Board = tf.Board and tf.FlightDateUTC between tb.DateBegUTC and tb.DateEndUTC
	group by tf.FlightDateUTC, tf.FlightNumber 
	
select STRFTIME('%W', FlightDateUTC),
		tf.board,
		sum(tf.pax),
		sum(tb.CapC + tb.CapY),
		ROUND(100 * SUM(CAST(tf.Pax as float)) / sum(tb.CapC + tb.CapY), 3) as percent
		from tst_flights tf
		inner join tst_boardcap tb on tb.Board = tf.Board and tf.FlightDateUTC between tb.DateBegUTC and tb.DateEndUTC
	group by STRFTIME('%W', FlightDateUTC), tf.board
	having STRFTIME('%W', FlightDateUTC) = '29'
