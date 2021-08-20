Function Convert-EpochTime { 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int64]$EpochTimestamp,

        [Parameter(Mandatory=$false)]
        [switch]$ConvertTime
    )

    if(($EpochTimestamp).ToString().Length -ge 13) {
        $time = (New-Object -TypeName DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0).AddMilliseconds($EpochTimestamp)
    } else {
        $time = (New-Object -TypeName DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0).AddSeconds($EpochTimestamp)
    }

    if($ConvertTime) {
        if((Get-Date).IsDaylightSavingTime()) {
            return $time.AddHours((Get-TimeZone).BaseUTCOffset.Hours + 1)
        } else {
            return $time.AddHours((Get-TimeZone).BaseUTCOffset.Hours)
        }
    } else {
        return $time    
    }
}

Function Get-SaturnaPrice {
    $pksEndpoint = "https://api.pancakeswap.info/api/v2/tokens/"
    $tokenAddress = "0x1e446cbea52badeb614fbe4ab7610f737995fb44"
    $apiReturn = (Invoke-WebRequest -uri ($pksEndpoint + $tokenAddress)).Content | ConvertFrom-Json

    $updateTime = Convert-EpochTime $apiReturn.updated_at -ConvertTime
    $price = $apiReturn.data.price
    
    $returnObj = [PSCustomObject]@{
        UpdateTime = $updateTime
        Price = $price
    }

    return $returnObj
}

Function Write-SaturnaValue {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Int64]$HoldingsAmount
    )
    [PSCustomObject]$obj = Get-SaturnaPrice
    [DateTime]$updateTime = $obj.UpdateTime
    [Decimal]$price = $obj.Price
    [Decimal]$value = $price * $HoldingsAmount
    $roundedValue = [Math]::Round($value,2)
    $roundedPrice = [Math]::Round($price,12)
    $holdingsAmountFormatted = '{0:N0}' -f $HoldingsAmount
    Write-Host "Updated at: $updateTime" -ForegroundColor "Cyan"
    Write-Host "Holdings: $holdingsAmountFormatted" -ForegroundColor "White"
    Write-Host "Price: $roundedPrice" -ForegroundColor "Magenta"
    Write-Host "Value: $roundedValue" -ForegroundColor "Green" -NoNewLine
}

Function Get-SaturnaUserInput {
    try {
        $amount = Read-Host "How much Saturna do you have?"
        $amount = [Math]::Round($amount)
        $amount = [Convert]::ToInt64($amount)        
    }
    catch {
        Write-Host "Something went wrong, try again. Numbers only!" -ForegroundColor Red     
        $amount = Get-SaturnaUserInput
    }   
    return $amount
}

$holdingsAmount = Get-SaturnaUserInput

do {
    [Console]::Title = "Saturna Watcher"
    Clear-Host
    Write-SaturnaValue -HoldingsAmount $holdingsAmount
    Start-Sleep 300
} while ($true)