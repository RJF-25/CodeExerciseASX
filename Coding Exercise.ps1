
## Variable Declaration -->
$Wtitle    = 'GRACE ASX'
$Wquestion = 'Do you want to start trading?'
$Wchoices  = '&Yes', '&No'
$GraceWallet = 0
$YourMoney = 500
$highPrice = 0
[bool]$blBuy = $false
[bool]$TradingStop = $false

[datetime]$TradeTime = "10:00 AM"
## <--

do{ # I use loop, so user can choose to continue or end the process after one another

    <#
    .SYNOPSIS
   
    Trading Starts 10AM until 10PM Local Time
    Buy First before Selling
    function to retrieve (Generate) yesterday’s GraceCoin prices
    function that takes an array of GraceCoin prices and returns the best profit
    The values are the price in dollars of a single GraceCoin
    The indexes are the time in minutes past trade opening time

    
    .DESCRIPTION
    Buying and Selling Coins
    
    .EXAMPLE
    1 Grace Coin * price(e.g $5) = Total
    The total will be subracted from the transaction money
    and summarized Total Grace Coin and Money left also profit
    from buying to selling.
    
    .NOTES
    I use combination of Array and Radom Number as the source of Coin Pricing
    but unable to keep the value of my Variables so it can use for Selling
    Once the script starts after 1 transaction, everthing will back to the default value
    that i have setup.

    Unfortunately, It will work only for Buying.

    I suggest to use any form of saving value for Instance .CSV,.xlsx, database connection

    also for > 1 minute between purchase and selling. for me it needs time difference.
    I try this but no luck

        $current = Get-Date

        $end= Get-Date

        $diff= New-TimeSpan -Start $current -End $end

        Write-Output "Time difference is: $diff"
            #>
function buyCoins { 

    $dte = Get-Date
    $CurrentTime = $dte.ToString("hh:mm tt")
    $TTime = $TradeTime.ToString("hh:mm tt")
    
    If ($TTime -eq $CurrentTime)
    {
        Write-Host 'Trading Starts After 10:00 AM'
    }else{
            $question = 'Please choose Buy or Sell Coin(s)'
            $choices  = '&Buy', '&Sell'
    
            $show_decision = $Host.UI.PromptForChoice("", $question, $choices,0)
    
            if($show_decision -eq 0){

                    $BuyCoins = Read-Host `n'How many Coins do you want to buy?'

                    $BuyCoinsTotal = [int]$BuyCoins * [int]$highPrice
                    $Total_Buy_Coin = $BuyCoinsTotal
                    $YourMoney = $YourMoney - $Total_Buy_Coin

                    if ($YourMoney -gt $Total_Buy_Coin){
                    Write-Host  'You have ' $buyCoins 'Grace Coin(s) and Your Money Total is $' $YourMoney

                    }else{
                        Write-Host 'You have insuficient balance. Please reload to buy ' $BuyCoins 'GraceCoins Thank you'
                        Write-Host 'Transaction Cancelled.'
                    }
                    

                $blBuy = $true
            }else{
                If ($blBuy -eq $true){
                    
                    Write-Host 'Sell'



                }else{
                    Write-Host 'Please Buy Coins First'
                    Exit-PSSession
                }
                
    
            }
    }
    
    }
    
$Welcome_decision = $Host.UI.PromptForChoice($wtitle, $Wquestion, $Wchoices,0)

if ($Welcome_decision -eq 0) {

    Write-Host `n'You have' $GraceWallet 'Grace Coins in you wallet'`n `
                     'and Your money is $'$YourMoney


    $question = 'Do you want to show yesterday''s price?'
    $choices  = '&Yes', '&No'

    $show_decision = $Host.UI.PromptForChoice("", $question, $choices,0)

    if($show_decision -eq 0){
        $addHrs = 1
        $Yeterday_Prices = New-Object System.Collections.Generic.List[System.Object]

        Write-Host `n 'Here are The prices from Yesterday' `n

        for($addHrs ; $addHrs -le 12;$addHrs++)
        {
            
        $YPrices = Generate_RadomNumber
        $Yeterday_Prices.Add($YPrices)

        $dte = Get-Date
        $dte = $dte.AddDays(-1).ToString("dd/MM/yyyy ")  + `
                $TradeTime.AddHours($addHrs).ToString("hh:mm tt") + `
                ' $' + $YPrices + ' per GraceCoin'
            
        Write-host $dte

        }
    
        $Ymaxpricevalue=[int]($Yeterday_Prices | Measure-Object -Maximum).Maximum

        Write-host `n`n 'The highest Price for Yesterday is $' $Yeterday_Prices[$Yeterday_Prices.IndexOf($Ymaxpricevalue)]
        $highPrice = $Yeterday_Prices[$Yeterday_Prices.IndexOf($Ymaxpricevalue)]
        buyCoins
    }else{

     
        $Today_Prices = New-Object System.Collections.Generic.List[System.Object]
        $addHrs = 1
        Write-Host `n 'Here are The prices from Today' `n

        for($addHrs ; $addHrs -le 12;$addHrs++)
        {
            
        $TPrices = Generate_RadomNumber
        $Today_Prices.Add($TPrices)

        $dte = Get-Date
        $dte = $dte.ToString("dd/MM/yyyy ")  + `
                $TradeTime.AddHours($addHrs).ToString("hh:mm tt") + `
                ' $' + $TPrices + ' per GraceCoin'
            
        Write-host $dte

        }
    
        $Tmaxpricevalue=[int]($Today_Prices | Measure-Object -Maximum).Maximum

        Write-host `n`n 'The highest Price for Today is $' $Today_Prices[$Today_Prices.IndexOf($Tmaxpricevalue)]
        $highPrice =  $Today_Prices[$Today_Prices.IndexOf($Tmaxpricevalue)]

        buyCoins
    }

} else {
    Write-Host 'Thank you.bye for now :-)'
    $TradingStop = $true
}

function Generate_RadomNumber(){
    $numm = Get-Random -Minimum 1 -Maximum 20
    return $numm
}
}while ($TradingStop -eq $false) 