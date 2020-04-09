--App names that appear in both stores
SELECT app_store_apps.name, play_store_apps.name
FROM app_store_apps LEFT JOIN play_store_apps
USING(name)
WHERE app_store_apps.name is not null AND play_store_apps.name is not null;

--Comparing prices - cheaper on Apple
SELECT app_store_apps.name AS app_name, play_store_apps.name AS play_name, app_store_apps.price AS app_price, play_store_apps.price AS play_price
FROM app_store_apps LEFT JOIN play_store_apps
USING(name)
WHERE app_store_apps.name is not null AND play_store_apps.name is not null
ORDER by app_price DESC;

--Purchase Price
SELECT app_store_apps.name AS app_name, play_store_apps.name AS play_name,
(CAST(app_store_apps.price as decimal) *10000) AS app_purchase_price,
(CAST(REPLACE(TRIM(play_store_apps.price), '$', '') AS decimal) *10000) AS play_purchase_price
FROM app_store_apps LEFT JOIN play_store_apps
USING(name)
WHERE app_store_apps.name is not null
AND play_store_apps.name is not null
ORDER by play_purchase_price DESC;

--Install count for play store:
SELECT (REPLACE (install_count,'+','')), name
FROM play_store_apps
ORDER BY install_count DESC;
