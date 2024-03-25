//home page profiles display
async function fetchProfiles(){
    const response=await fetch('https://dummyjson.com/users');
    const data=await response.json();
    return data.users;
}
async function displayProfiles(){
    const profiles=await fetchProfiles();
    const profilesSection=document.getElementById('profiles');
    profiles.forEach(profile=>{
        const profileCard=document.createElement('div');
        profileCard.classList.add('profile-card');
        profileCard.innerHTML=`
        <img src="${profile.image}" alt="${profile.username}" onclick="showProfile(this)">
        <div class="profile-details">
        <h2>${profile.id}</h2>
        <p>Name: ${profile.firstName} ${profile.lastName}</p>
        <p>Mail ID: ${profile.email}</p>
        <p>Phone number: ${profile.phone}</p>
        </div>
        `;
        profilesSection.appendChild(profileCard);
    });
}
function showProfile(image){
    const profileCards=document.querySelectorAll('.profile-card');
    profileCards.forEach(card=>{
        card.style.display='none';
    });
    const profileCard=image.parentElement;
    profileCard.style.display='block';

}
displayProfiles();


//gallery display
async function displayGalleryProfiles(){
    const profiles=await fetchProfiles();
    const profilesSection=document.getElementById('imageContainer');
    profiles.forEach(profile=>{
        const profileCard=document.createElement('div');
        profileCard.classList.add('profile-card');
        profileCard.innerHTML=`
        <h2>${profile.id}</h2>
        <img src="${profile.image}" alt="${profile.username}" onclick="showFullProfile('${profile.image}')">
        `;
        profilesSection.appendChild(profileCard);
    });
}

async function showFullProfile(image){
    const profiles=await fetchProfiles();
    const profilesSection=document.getElementById('imageContainer');
    profiles.forEach(profile=>{
        if(profile.image===image){
        const profileCard=document.createElement('div');
        profileCard.classList.add('profile-card-1');
        profileCard.innerHTML=`
        <div class="profile-details">
        <img src="${profile.image}" alt="${profile.username}">
        <h2><b>ID:</b> ${profile.id}</h2>
        <p><b>First Name:</b> ${profile.firstName}</p>
        <p><b>Last Name: </b>${profile.lastName}</p>
        <p><b>Maiden Name: </b>${profile.maidenName}</p>
        <p><b>Age: </b>${profile.age}</p>
        <p><b>Gender:</b> ${profile.gender}</p>
        <p><b>Mail ID:</b> ${profile.email}</p>
        <p><b>Phone Number:</b> ${profile.phone}</p>
        <p><b>User Name:</b> ${profile.username}</p>
        <p><b>Date of Birth:</b> ${profile.birthDate}</p>
        <p><b>Blood group:</b> ${profile.bloodGroup}</p>
        <p><b>Height:</b>${profile.height}</p>
        <p><b>Weight:</b> ${profile.weight}</p>
        <p><b>Eye Colour:</b> ${profile.eyeColor}</p>
        <p><b>Hair- Colour:</b> ${profile.hair.color}, Type: ${profile.hair.type}</p>
        <p><b>Domain:</b> ${profile.domain}</p>
        <p><b>IP address:</b> ${profile.ip}</p>
        <p><b>University: </b>${profile.university}</p>
        <p><b>Residential Address:</b> ${profile.address.address},${profile.address.city}, ${profile.address.state}- ${profile.address.postalCode}</p>
        <p><b>Bank Details:</b></p>
        <p><b>Card Number:</b> ${profile.bank.cardNumber},Card type: ${profile.bank.cardType}, Currency: ${profile.bank.currency}</p>
        <p><b>Company Address:</b> ${profile.company.address.address},${profile.company.address.city}, ${profile.company.address.state}- ${profile.company.address.postalCode}</p>
        <p><b>EIN:</b> ${profile.ein}</p>
        <p><b>SSN:</b> ${profile.ssn}</p>
        <p><b>User agent:</b> ${profile.userAgent}</p>
        </div>
        `;
        profilesSection.innerHTML='';
        profilesSection.appendChild(profileCard);
        }
    });

}
displayGalleryProfiles();


