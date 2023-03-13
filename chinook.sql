SELECT sum(i.total),
       c.FIRSTNAME||' '||c.LASTNAME AS fullname
FROM invoice i
JOIN customer c ON c.customerid = i.CustomerId
GROUP BY 2
ORDER BY 1 DESC ;

SELECT at.name,
       count(t.trackid)
FROM genre g
JOIN track t ON t.genreid = g.genreid
JOIN album a ON a.albumid = t.AlbumId
JOIN artist AT ON at.artistid = a.artistid
WHERE g.name like 'rock'
GROUP BY 1
ORDER BY 2 DESC ;

WITH top_artist AS
  (SELECT at.artistid,
          at.name AS at_name,
          sum(il.unitprice)
   FROM track t
   JOIN album a ON a.albumid = t.AlbumId
   JOIN artist AT ON at.artistid = a.artistid
   JOIN invoiceline il ON il.trackid = t.trackid
   JOIN invoice i ON i.invoiceid = il.InvoiceId
   JOIN customer c ON c.customerid = i.customerid
   GROUP BY 1
   ORDER BY 3 DESC
   LIMIT 1)
SELECT at.name,
       c.customerid,
       c.firstname f_name,
       c.lastname l_name,
       sum(il.unitprice * il.quantity) AS amount_spent
FROM track t
JOIN album a ON a.albumid = t.AlbumId
JOIN artist AT ON at.artistid = a.artistid
JOIN invoiceline il ON il.trackid = t.trackid
JOIN invoice i ON i.invoiceid = il.InvoiceId
JOIN customer c ON c.customerid = i.customerid
WHERE at.name =
    (SELECT at_name
     FROM top_artist)
GROUP BY 1,
         2
ORDER BY 5 DESC ;

WITH t2 AS
  (SELECT count(g.name) count_genre,
          c.country country,
          g.Name name
   FROM customer c
   JOIN invoice i ON c.customerid = i.CustomerId
   JOIN invoiceline il ON il.invoiceid = i.InvoiceId
   JOIN track t ON t.trackid = il.TrackId
   JOIN genre g ON g.genreid = t.GenreId
   GROUP BY 2,
            3)
SELECT t2.count_genre,
       t2.country,
       t2.name
FROM t2
JOIN
  (SELECT max(count_genre) unit,
          country
   FROM t2
   GROUP BY 2)t3 ON t2.country = t3.country
AND t2.count_genre = t3.unit
GROUP BY 2,
         3 ;