# MarvelAPI

Simple app that lists and search for marvel and show their detail using MVVM architecture.

## Architecture

``MVVM``
- Mainly uses the structure from MVVM.
- Aims to keep everything simple, but modular and reusable.
- Views more made programmatically without using Xib or storyboards to avoid any problems with conflicts if someone wants to work on parallel
- Unit test added for ViewModels and also a minor integration test
- UI test added to see the impact of the scroll and also to test that the search bar components is working as expected
- The app suports dark mode and portrait and landscape modes

## Pods Used

- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [Moya](https://github.com/Moya/Moya)

### Images

*Marvel character list

<img width="347" alt="Screen Shot 2021-09-28 at 6 44 42 PM" src="https://user-images.githubusercontent.com/17602606/135180127-5d58e283-bbf9-4846-8a48-19c51ee69348.png">

*Marvel character detail

<img width="369" alt="Screen Shot 2021-09-28 at 5 39 41 PM" src="https://user-images.githubusercontent.com/17602606/135180167-6e307993-a11a-4b00-bb8f-89bd61d6e2c3.png">

*Marvel wiki page

<img width="371" alt="Screen Shot 2021-09-28 at 6 46 23 PM" src="https://user-images.githubusercontent.com/17602606/135180229-10b8a691-bcf2-4d2e-9d29-09045f9ed8d9.png">

*Landscape mode

<img width="791" alt="Screen Shot 2021-09-28 at 5 40 32 PM" src="https://user-images.githubusercontent.com/17602606/135180320-ed68f3c4-4f26-447c-97d0-4ef81b99941f.png">

