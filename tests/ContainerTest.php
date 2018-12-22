<?hh // strict

use type Acme\HackDi\Container;
use type Acme\HackDi\Scope;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerTest extends HackTest {

  public function testHasIdentifierShoulbReturnBool(): void {
    $container = new Container();
    expect($container->has(\stdClass::class))->toBeFalse();
    $container->set(\stdClass::class, ($container) ==> new \stdClass());
    expect($container->has(\stdClass::class))->toBeTrue();
  }

  public function testShouldBePrototypeInstance(): void {
    $container = new Container();
    $container->set(\stdClass::class, ($container) ==> new \stdClass());
    $stdClass = $container->get(\stdClass::class);
    expect($stdClass)->toBeInstanceOf(\stdClass::class);
    expect($container->get(\stdClass::class))->toNotBeSame($stdClass);
  }

  public function testShouldBeSingletonInstance(): void {
    $container = new Container();
    $container->set(
      \stdClass::class, 
      ($container) ==> new \stdClass(),
      Scope::SINGLETON,
    );
    $stdClass = $container->get(\stdClass::class);
    /* HH_FIXME[4064] for testing */
    /* HH_FIXME[4053] for testing */
    $stdClass->testing = 1;
    expect($stdClass)->toBeInstanceOf(\stdClass::class);
    $second = $container->get(\stdClass::class);
    expect($second)->toBeSame($stdClass);
    /* HH_FIXME[4064] for testing */
    /* HH_FIXME[4053] for testing */
    expect($second->testing)->toBeSame(1,);
  }
}
