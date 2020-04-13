/*d. For every half point that an app gains in rating, its projected lifespan 
increases by one year, in other words, an app with a rating of 0 
can be expected to be in use for 1 year, an app with a rating of 1.0 
can be expected to last 3 years, and an app with a rating of 4.0 
can be expected to last 9 years. 

--Ratings should be rounded to the nearest 0.5 
to evaluate its likely longevity.*/

--generate a list of apps for each store and their calculated life span
SELECT genres, name, rating, install_count,
	CASE WHEN rating > 3.0 then 'high rating'
	WHEN rating < .5 then 'low rating'
	ELSE 'medium rating'
	END AS rating_category
FROM play_store_apps
WHERE rating is NOT NULL
GROUP BY genres, name, rating, install_count
ORDER BY install_count;


--and for APP STORE

SELECT primary_genre, name, rating, review_count,
	CASE WHEN rating > 3.0 then 'high rating'
	WHEN rating < .6 then 'low rating'
	ELSE 'medium rating'
	END AS rating_category
FROM app_store_apps
WHERE rating is NOT NULL
GROUP BY primary_genre, name, rating, review_count
ORDER BY rating DESC, review_count DESC;
