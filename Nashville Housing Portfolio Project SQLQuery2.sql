
-- CLEANING DATA IN SQL QUERIES --

Select *
From PortfolioProject1.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------


-- Standardize Data Format


Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject1.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)


------------------------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address Data


Select *
From PortfolioProject1.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID


Select orig.ParcelID, orig.PropertyAddress, test.ParcelID, test.PropertyAddress, ISNULL(orig.PropertyAddress, test.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing orig
JOIN PortfolioProject1.dbo.NashvilleHousing test
	on orig.ParcelID = test.ParcelID
	AND orig.[UniqueID ] <> test.[UniqueID ]
Where orig.PropertyAddress is null


Update orig
SET PropertyAddress = ISNULL(orig.PropertyAddress, test.PropertyAddress)
From PortfolioProject1.dbo.NashvilleHousing orig
JOIN PortfolioProject1.dbo.NashvilleHousing test
	on orig.ParcelID = test.ParcelID
	AND orig.[UniqueID ] <> test.[UniqueID ]
Where orig.PropertyAddress is null


-------------------------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject1.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject1.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
From PortfolioProject1.dbo.NashvilleHousing




Select OwnerAddress
From PortfolioProject1.dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioProject1.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE NashvilleHousing 
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)


ALTER TABLE NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


---------------------------------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" Field


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject1.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant 
	   END
From PortfolioProject1.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant 
	   END



------------------------------------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates


WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
				UniqueID
				) row_num
From PortfolioProject1.dbo.NashvilleHousing
-- Order by ParcelID
)
Select *
From RowNumCTE
Where row_num  > 1
ORDER BY PropertyAddress


----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns



Select *
From PortfolioProject1.dbo.NashvilleHousing


ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN SaleDate