--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

select film_id, title, special_features
from film
where special_features && array['Behind the Scenes'];



--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select film_id, title, unnest
from (
	select title, unnest(special_features), film_id
	from film) title 
where unnest = 'Behind the Scenes';

select film_id, title, special_features 
from film
where 'Behind the Scenes' = any(special_features);



--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

with cte as (
	select film_id, title, special_features
	from film
	where special_features && array['Behind the Scenes'])
select c.customer_id, count(cte.film_id) as film_count
from customer c
join rental r on c.customer_id = r.customer_id 
join inventory i on r.inventory_id = i.inventory_id 
join cte on cte.film_id = i.film_id 
group by c.customer_id 
order by c.customer_id;



--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.


select customer_id, count(f.film_id) as film_count 
from (select film_id, title, special_features
from film
where special_features && array['Behind the Scenes']) f
join  inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
group by customer_id 
order by customer_id;


--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view one as 
	select customer_id, count(f.film_id) as film_count 
	from (select film_id, title, special_features
		from film
		where special_features && array['Behind the Scenes']) f
	join  inventory i on f.film_id = i.film_id 
	join rental r on i.inventory_id = r.inventory_id 
	group by customer_id 
	order by customer_id
	
refresh materialized view one 



--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит быстрее
--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса

1.  С оператором ANY поиск значения в массиве происходит быстрее
2.  Оба варианта вычисляются примерно одинаково, но вариант с использованием подзапроса немного быстрее

