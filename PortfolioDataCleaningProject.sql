select *
from NashvilleHousing

-- Populate propertyadress

SELECT PropertyAddress 
FROM projectportfolio.dbo.NashvilleHousing
WHERE PropertyAddress is null



SELECT *
FROM projectportfolio.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

--Using Joins

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM projectportfolio.dbo.NashvilleHousing a
join projectportfolio.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM projectportfolio.dbo.NashvilleHousing a
join projectportfolio.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
WHERE a.PropertyAddress is null

--Breaking Down PropertyAddress into Individual Columns(Address,City,State)

SELECT PropertyAddress
FROM projectportfolio.dbo.NashvilleHousing

--Using Substring

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address
FROM projectportfolio.dbo.NashvilleHousing

--Takeout comma from all Address

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
FROM projectportfolio.dbo.NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
FROM projectportfolio.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT *
FROM projectportfolio.dbo.NashvilleHousing

----Splitting Owners address Using PARSENAME

SELECT OwnerAddress
FROM projectportfolio.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM projectportfolio.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--REMOVE DUPLICATES

      WITH RowNumCTE AS(
      SELECT *,
             ROW_NUMBER() OVER (
	         PARTITION BY ParcelID,
	                      PropertyAddress,
					      SalePrice,
					      SaleDate,
					      LegalReference
				          ORDER By 
					      UniqueID
				)row_num
FROM projectportfolio.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num>1
--ORDER BY PropertyAddress


SELECT *
FROM projectportfolio.dbo.NashvilleHousing

--Delete Unused Columns

ALTER TABLE projectportfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,PropertyAddress,TaxDistrict