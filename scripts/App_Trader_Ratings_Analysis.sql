/*d. For every half point that an app gains in rating, its projected lifespan 
increases by one year, in other words, an app with a rating of 0 
can be expected to be in use for 1 year, an app with a rating of 1.0 
can be expected to last 3 years, and an app with a rating of 4.0 
can be expected to last 9 years. 

--Ratings should be rounded to the nearest 0.5 
to evaluate its likely longevity.*/
--generate a list of apps for each store and their calculated life span

/*SELECT genres, to_number(install_count, 'G9999999999') AS clean_install_count
FROM play_store_apps
ORDER BY clean_install_count DESC
LIMIT 10;*/

SELECT genres, name, rating, price, to_number(install_count, 'G9999999999') AS clean_install_count,
	CASE WHEN rating > 3.0 then 'high rating'
	WHEN rating < .5 then 'low rating'
	ELSE 'medium rating'
	END AS rating_category
FROM play_store_apps
WHERE rating is NOT NULL
GROUP BY genres, name, rating, price, clean_install_count
ORDER BY clean_install_count DESC;


--and for APP STORE

SELECT primary_genre, name, rating, review_count::numeric, price,
	CASE WHEN rating > 3.0 then 'high rating'
	WHEN rating < .6 then 'low rating'
	ELSE 'medium rating'
	END AS rating_category
FROM app_store_apps
WHERE rating is NOT NULL
GROUP BY primary_genre, name, rating, review_count, price
ORDER BY review_count DESC;

--Jacob's Table

SELECT a.name, cast(a.review_count as integer) + p.reviews as combined_reviews, 
 round(a.rating, 1) as app_rating, round(p.rating, 1) as play_rating, a.price as app_price,
 p.price as play_price
FROM app_store_apps as a
JOIN (SELECT name, max(review_count) as reviews, rating, price
FROM play_store_apps
group by price, rating, name) as p
ON a.name = p.name
ORDER BY combined_reviews desc;

--PURCHASE PRICE--

--SELECT name, price, ((CAST(price as decimal),2) * 10000) AS purchase_price
--FROM play_store_apps;

--SELECT name, price, (to_number(price, 'G999D999') * 10000) AS purchase_price
--FROM play_store_apps
--ORDER BY purchase_price DESC;

--Here’s the version using review_count and it looks more like expected, but we need to weed out the duplicates using Jacob’s joined table, and find a way to add the install_count cases from Cat’s work above, which I haven’t done yet:
SELECT app_store_apps.name AS app_name,
	app_store_apps.primary_genre,
	play_store_apps.name AS play_name,
	play_store_apps.genres,
	play_store_apps.review_count AS ps_apps_review,
	app_store_apps.review_count AS app_apps_review,
	play_store_apps.rating AS ps_apps_rating,
	CASE WHEN CAST(app_store_apps.price as money) <='0.99' THEN '$10,000'
		 WHEN CAST(app_store_apps.price as money) >'0.99' 
		 THEN CAST(app_store_apps.price as money)*10000
		 END AS app_purch_price,
	CASE WHEN CAST(REPLACE(TRIM(play_store_apps.price), '$', '') AS money) <='0.99'
		 THEN '$10,000'
		 WHEN CAST(REPLACE(TRIM(play_store_apps.price), '$', '') AS money) >'0.99' 
		 THEN CAST(play_store_apps.price as money)*10000
		 END AS play_purch_price
FROM app_store_apps LEFT JOIN play_store_apps
USING(name)
WHERE app_store_apps.name is not null 
	AND play_store_apps.name is not null
	AND play_store_apps.rating > 4.5
ORDER by ps_apps_review DESC, ps_apps_rating DESC
LIMIT 25;

--Refined list with Profits
SELECT a.name, cast(a.review_count as integer) + p.reviews as combined_reviews,
	round(a.rating, 1) as app_rating, round(p.rating, 1) as play_rating, a.price as app_price,
	p.price as play_price, a.primary_genre as genre
FROM app_store_apps as a
JOIN (SELECT name, max(review_count) as reviews, rating, price
FROM play_store_apps
group by price, rating, name) as p
ON a.name = p.name
WHERE a.rating >= '4.5' and p.rating >= '4.3'
	and a.price <= '1' and p.price <= '1'
ORDER BY combined_reviews desc;











