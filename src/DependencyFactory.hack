/**
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * This software consists of voluntary contributions made by many individuals
 * and is licensed under the MIT license.
 *
 * Copyright (c) 2018-2019 Yuuki Takezawa
*/

namespace Nazg\Glue;

use type ReflectionClass;

final class DependencyFactory {

  public function __construct(
    private \Nazg\Glue\Container $container
  ) {}

  public function makeInstance<T>(
    typename<T> $concrete
  ): DependencyInterface {
    return new Dependency(
      new Injector(new ReflectionClass($concrete))
    );
  }

  public function makeInstanceByProvider<T>(
    ProviderInterface<T> $provider
  ): DependencyInterface {
    return new DependencyProvider($provider);
  }
}
